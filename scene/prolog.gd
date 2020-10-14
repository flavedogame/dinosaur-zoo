extends Control

onready var Alex = $prolog_scene/Alex
onready var Spaceship = $prolog_scene/Spaceship

onready var comet = $prolog_scene/comet
onready var comet_start = $prolog_scene/comet_start
onready var comet_appear = $prolog_scene/comet_appear
onready var comet_target = $prolog_scene/comet_target

onready var missile = $prolog_scene/missile

var dialog_instance

onready var tween = $prolog_scene/Tween

var dialog_folder = "res://resources/dialog"
var dialog = preload("res://scene/UI/Dialog.tscn")

onready var prolog_scene = $prolog_scene
var prolog

func _ready():
	load_prolog()
	dialog_instance = DialogManager.select_dialog_multiple(self,prolog)
	#todo: why. if I don't have this, the first dialog would be on a weird place
	yield(get_tree(), 'idle_frame')
	add_child(dialog_instance)
	dialog_instance.start_dialog()
	
func load_prolog():
	var file_path = '%s/%s.json' % [dialog_folder, "prolog"]
	prolog = Util.load_json(file_path)

func get_dialog_size():
	return Vector2(300,100)

func end():
	Events.emit_signal("finish_prolog")

func trigger(trigger_name):
	match trigger_name:
		"comet_appear":
			yield(comet_appear(),"completed")
		"destroy_comet":
			yield(destroy_comet(),"completed")
		"end":
			end()
	yield(get_tree(), 'idle_frame')

func destroy_comet():
#	look_at()
#	var angle_to = rad2deg(missile.position.angle_to(comet.position))
#	print(missile.position.angle_to(comet.position))
#	print(angle_to)
	missile.look_at(comet.get_global_position())
	tween.interpolate_property(
			missile, 
			"position", 
			missile.position, comet.position, 0.5,
			Tween.TRANS_QUART, Tween.EASE_IN)
			
	tween.start()
	yield(tween,"tween_completed")
	missile.queue_free()
	comet.playing = true
	yield(comet,"animation_finished")
	comet.queue_free()
	yield(get_tree(), 'idle_frame')

func comet_appear():
	tween.interpolate_property(
			comet, 
			"position", 
			comet_start.position, comet_target.position, 20,
			Tween.TRANS_QUART, Tween.EASE_OUT)
			
	tween.start()
	yield(get_tree().create_timer(1), "timeout")
#	yield(tween,"tween_completed")
#	tween.interpolate_property(
#			comet, 
#			"position", 
#			comet_appear.position, comet_target.position, 10,
#			Tween.TRANS_QUART, Tween.EASE_IN)
#	tween.start()		




func _on_Button_pressed():
	if dialog_instance:
		dialog_instance.skip_dialog()
