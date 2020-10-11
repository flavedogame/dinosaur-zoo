extends Control

var dialog_wait_time = 3
var dialog
var current_dialog
onready var label = $ColorRect/RichTextLabel
onready var panel = $ColorRect
onready var timer = $Timer
# Called when the node enters the scene tree for the first time.
func _ready():
	
	#label.bbcode_text = dialog["first"].content
	pass
func init(_position, _dialog):
	dialog = _dialog
	rect_position = _position
	
func start_dialog():
	current_dialog = dialog["first"]
	yield(show_one_dialog(),"completed")
	
	
func show_one_dialog():
	label.bbcode_text = current_dialog.content
	timer.wait_time = dialog_wait_time
	timer.start()
	yield(timer,"timeout")
	yield(next(),"completed")

func next():
	if current_dialog.has("next"):
		current_dialog = dialog[current_dialog.next]
		yield(show_one_dialog(),"completed")
	else:
		yield(get_tree(), 'idle_frame')
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
