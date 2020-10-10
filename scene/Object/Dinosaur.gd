extends Node2D

onready var sprite = $Sprite

var waiting_time
var target_position
var direction
var walk_time = 2
var face

# Called when the node enters the scene tree for the first time.
func _ready():
	if face == 1:
		sprite.scale.x = -sprite.scale.x
	pass # Replace with function body.

func _process(delta):
	if direction:
		if (target_position-position).dot(direction)<0:
			return
		position += delta * direction
	pass

func init_position(_position,_target,_face):
	position = _position
	target_position = _target
	direction = (target_position-position)/walk_time
	face = _face

func init(_waiting_time):
	waiting_time = _waiting_time
