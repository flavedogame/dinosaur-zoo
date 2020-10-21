extends Control


#for dialog

onready var dialog_view = $zoo_scene/TileMap/dialog_view
onready var player_position = $zoo_scene/TileMap/dialog_view/PlayerPosition
onready var Alex = $zoo_scene/TileMap/Alex
onready var Curator = $zoo_scene/TileMap/dialog_view/Curator
onready var Center = $zoo_scene/TileMap/Center
onready var ingame_dialogs = $zoo_scene/TileMap/dialog
onready var ingame_quests = $zoo_scene/TileMap/quest
onready var ingame_warnings = $zoo_scene/TileMap/warning
onready var blackout = $CanvasLayer/BlackOut
onready var blackout_label = $CanvasLayer/BlackOut/Label

onready var curator_dialog = $zoo_scene/TileMap/dialog

onready var zoo_scene = $zoo_scene

onready var tween = $Tween
var dialog_instance
var dialog_folder = "res://resources/dialog"
var coreGameManager = preload("res://scene/CoreGameManager.tscn")


var dialog


func get_level():
	return LevelManger.current_level
	
func load_dialog_view():
	dialog_view.visible = true
	Curator.position = Util.position_to_position(Curator.position)
	Alex.position = Util.position_to_position(player_position.position) 

func _ready():
	#Center.position = Vector2(0,0)
	Center.position -= Util.normal_dialog_size/4/2
	
	Util.visitor_dialog_parent = ingame_dialogs
	Util.visitor_quest_parent = ingame_quests
	Util.visitor_warning_parent = ingame_warnings
	Util.Hud = $HUD
	Util.tilemap = $zoo_scene/TileMap
	Events.connect("level_end",self,"level_end")
	
	
	LevelManger.save_level_data()
	
func level_continue():
	LevelManger.next_level()
	ResourceManager.level_start()
	#wait until black in and out finished
	level_start()
	
func level_start():
	
	
	yield(show_blackout(),"completed")
	hide_balckout()
	
	load_dialog_view()
	load_level_dialog()
	show_current_dialog()
	
func level_end():
	ResourceManager.is_main_game_started = false
	Util.clear_all_children(ingame_dialogs)
	Util.clear_all_children(ingame_quests)
	Util.clear_all_children(ingame_warnings)
	Util.core_game_manager.queue_free()
	
	load_dialog_view()
	load_end_dialog()
	show_current_dialog()
	
func load_level_dialog():
	var file_path = '%s/%s%d.json' % [dialog_folder, "level",get_level()]
	dialog = Util.load_json(file_path)
	
func load_end_dialog():
	var file_path = '%s/%s.json' % [dialog_folder, "levelEnd"]
	dialog = Util.load_json(file_path)
	
func show_current_dialog():
	dialog_instance = DialogManager.select_dialog_multiple(self,dialog)
	#todo: why. if I don't have this, the first dialog would be on a weird place
	yield(get_tree(), 'idle_frame')
	curator_dialog.add_child(dialog_instance)
	dialog_instance.start_dialog()

func finishLevelStart():
	#todo curator leave
	var coreGameManager_instance = coreGameManager.instance()
	ResourceManager.is_main_game_started = true
	zoo_scene.add_child(coreGameManager_instance)
	dialog_view.visible = false
	dialog_instance.queue_free()
	#Events.emit_signal("finish_level_start_dialog")
	
func show_blackout():
	blackout.visible = true
	blackout_label.text = "Day %d"%(LevelManger.current_level+1)
	yield(get_tree().create_timer(2), "timeout")
	
func hide_balckout():
	blackout.visible = false
	
func finishLevelEnd():
	#todo black in and out
	dialog_view.visible = false
	dialog_instance.queue_free()
	
	LevelManger.save_level_data()
	
	LevelManger.next_level()
	ResourceManager.level_start()
	#wait until black in and out finished
	level_start()

func punish():
	yield(Util.Player.do_damage(10),"completed")
	
func curator_move(dir):
	Util.position_move(Curator,dir)
	yield(get_tree().create_timer(0.4), "timeout")

func curator_spin():
	yield(curator_move(Vector2.UP),"completed")
	yield(curator_move(Vector2.LEFT),"completed")
	yield(curator_move(Vector2.DOWN),"completed")
	yield(curator_move(Vector2.RIGHT),"completed")

func trigger(trigger_name):
	match trigger_name:
		"finishLevelStart":
			finishLevelStart()
		"finishLevelEnd":
			finishLevelEnd()
		"punish":
			yield(punish(),"completed")
		"curator_spin":
			yield(curator_spin(),"completed")
	yield(get_tree(), 'idle_frame')


func _on_Button_pressed():
	if dialog_instance:
		dialog_instance.skip_dialog()

func _on_Button2_pressed():
	Events.emit_signal("game_end")
