extends Control

onready var Alex = $prolog_scene/Alex
onready var Spaceship = $prolog_scene/Spaceship

onready var comet = $prolog_scene/comet
onready var comet_start = $prolog_scene/comet_start
onready var comet_appear = $prolog_scene/comet_appear
onready var comet_target = $prolog_scene/comet_target

onready var tween = $prolog_scene/Tween

var dialog_folder = "res://resources/dialog"
var dialog = preload("res://scene/UI/Dialog.tscn")

onready var prolog_scene = $prolog_scene
var prolog

func _ready():
	load_prolog()
	var dialog_instance = DialogManager.select_dialog_multiple(self,prolog)
	prolog_scene.add_child(dialog_instance)
	dialog_instance.start_dialog()
	
func load_prolog():
	var file_path = '%s/%s.json' % [dialog_folder, "prolog"]
	prolog = Util.load_json(file_path)

func get_dialog_size():
	return Vector2(300,100)

func trigger(trigger_name):
	match trigger_name:
		"comet_appear":
			yield(comet_appear(),"completed")
		"destroy_comet":
			yield(destroy_comet(),"completed")

func destroy_comet():
	yield(get_tree(), 'idle_frame')

func comet_appear():
	tween.interpolate_property(
			comet, 
			"position", 
			comet_start.position, comet_appear.position, 1,
			Tween.TRANS_QUART, Tween.EASE_IN)
			
	tween.start()
	yield(tween,"tween_completed")
	tween.interpolate_property(
			comet, 
			"position", 
			comet_appear.position, comet_target.position, 100,
			Tween.TRANS_QUART, Tween.EASE_IN)
	tween.start()		


