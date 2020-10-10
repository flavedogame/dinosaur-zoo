extends Control


var dialog
onready var label = $ColorRect/RichTextLabel
onready var panel = $ColorRect
# Called when the node enters the scene tree for the first time.
func _ready():
	
	label.bbcode_text = dialog["first"].content
	pass
func init(_position, _dialog):
	dialog = _dialog
	rect_position = _position

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
