extends Node2D

func init(_position):
	position = _position

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.current_animation = "warning"
	$AnimationPlayer.play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
