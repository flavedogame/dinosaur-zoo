extends Control

var ending_name


var dialog_instance


var ending_folder = "res://resources/endings"
var dialog = preload("res://scene/UI/Dialog.tscn")

var ending_json

func init(_name):
	ending_name = _name
	

func _ready():
	MusicManager.play_music("ending")
	load_prolog()
	dialog_instance = DialogManager.select_dialog_multiple(self,ending_json,get_dialog_size())
	#todo: why. if I don't have this, the first dialog would be on a weird place
	yield(get_tree(), 'idle_frame')
	add_child(dialog_instance)
	dialog_instance.start_dialog()
	
func load_prolog():
	var file_path = '%s/%s.json' % [ending_folder, "ending"]
	ending_json = Util.load_json(file_path)[ending_name]

func get_dialog_size():
	return Util.screen_size*4

func end():
	Events.emit_signal("game_end")

func trigger(trigger_name):
	match trigger_name:
#		"comet_appear":
#			yield(comet_appear(),"completed")
#		"destroy_comet":
#			yield(destroy_comet(),"completed")
		"end":
			end()
	yield(get_tree(), 'idle_frame')




func _on_Button_pressed():
	if dialog_instance:
		dialog_instance.skip_dialog()
