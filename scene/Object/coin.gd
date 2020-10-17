extends Area2D

var value
var target_position
var origin_position

onready var tween = $Tween
onready var label = $Label
onready var raycast = $RayCast2D

func init(_position,_target,_value):
	value = _value
	target_position = _target
	origin_position = _position


# Called when the node enters the scene tree for the first time.
func _ready():
	if value:
		label.text = String(value)
		position= origin_position
		tween.interpolate_property(
				self, 
				"position", 
				position, target_position, 0.5,
				Tween.TRANS_QUART, Tween.EASE_IN)
		tween.start()
		yield(tween,"tween_completed")
	
func _process(delta):
	check_collide()
	
func check_collide():
	#print("check collide")
	var collider = raycast.get_collider()
	if collider:
		for i in collider.get_groups():
			if i == "player":
				Util.Player.do_damage()
				self.queue_free()
				
		
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
