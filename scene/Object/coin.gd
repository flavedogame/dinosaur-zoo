extends Area2D

var value = 4
var type = "coin"
var coin_type = 0
var target_position
var origin_position

var is_destoryed = false
var is_picked_up = false


onready var tween = $Tween
onready var label = $Node2D/Label
onready var raycast = $RayCast2D
onready var coin_sprite = $coin_sprite
onready var collision_shape = $CollisionShape2D

#var is_flying = true
var is_safe = true

var coin_type_sprites = [
	preload("res://art/object/coin_brown.png"),
	preload("res://art/object/coin_silver.png"),
	preload("res://art/object/coin_gold.png"),
]

func get_value():
	return value * pow(10, coin_type)

func init(_position,_target,_value):
	while _value>=10:
		_value/=10
		coin_type+=1
	value = _value
	target_position = _target
	origin_position = _position

func picked_up(_is_picked_up):
	is_picked_up = _is_picked_up
	get_node("CollisionShape2D").disabled= is_picked_up

# Called when the node enters the scene tree for the first time.
func _ready():
	update_visually()
	if origin_position:
		position = origin_position
		tween.interpolate_property(
				self, 
				"position", 
				position, target_position, 0.5,
				Tween.TRANS_QUART, Tween.EASE_IN)
		tween.start()
		yield(tween,"tween_completed")
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

func update_visually():
	label.text = String(value)
	coin_sprite.texture = coin_type_sprites[coin_type]

func destory():
	is_destoryed = true
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
