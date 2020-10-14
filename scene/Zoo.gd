extends Control


#for dialog
onready var Alex = $zoo_scene/TileMap/Alex
onready var Curator = $zoo_scene/TileMap/Curator
onready var Center = $zoo_scene/TileMap/Center

onready var curator_dialog = $zoo_scene/TileMap/dialog

onready var tween = $prolog_scene/Tween
var dialog_instance
var dialog_folder = "res://resources/dialog"
var dialog = preload("res://scene/UI/Dialog.tscn")
var coreGameManager = preload("res://scene/CoreGameManager.tscn")

var current_level = 1

onready var prolog_scene = $prolog_scene
var prolog

func get_level():
	return current_level

func _ready():
	#Center.position = Vector2(0,0)
	Center.position -= Util.normal_dialog_size/4/2
	load_level_dialog()
	dialog_instance = DialogManager.select_dialog_multiple(self,prolog)
	#todo: why. if I don't have this, the first dialog would be on a weird place
	yield(get_tree(), 'idle_frame')
	curator_dialog.add_child(dialog_instance)
	dialog_instance.start_dialog()
	
func load_level_dialog():
	var file_path = '%s/%s%d.json' % [dialog_folder, "level",get_level()]
	prolog = Util.load_json(file_path)

func end():
	#curator leave
	var coreGameManager_instance = coreGameManager.instance()
	add_child(coreGameManager_instance)
	#Events.emit_signal("finish_level_start_dialog")

func trigger(trigger_name):
	match trigger_name:
		"end":
			end()
	yield(get_tree(), 'idle_frame')


func _on_Button_pressed():
	if dialog_instance:
		dialog_instance.skip_dialog()
