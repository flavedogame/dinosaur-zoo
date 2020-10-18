extends Area2D

onready var raycast = $RayCast2D
onready var animation = $AnimationPlayer
onready var hold_item_position = $hold_item_position
onready var sprite = $Sprite

#ref https://kidscancode.org/godot_recipes/2d/grid_movement/
var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
var interact_input = "interact"
var save_step_count = 5
var position_index
var is_moving_waiting = false
var is_hiited = false

var holding_item

var last_steps:Array = []

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * Vector2(tile_size/2,0) 
	position_index = Util.position_to_index(position)
	position = Util.index_to_position(position_index)
	Util.Player = self
	
func get_input():
	
	if not is_moving_waiting and not is_hiited:
		if Input.is_action_pressed(interact_input):
			for dir in inputs.keys():
				if Input.is_action_just_pressed(dir):
					interact(inputs[dir])
		else:
			for dir in inputs.keys():
				if Input.is_action_pressed(dir):
					move(inputs[dir])

func _physics_process(delta):
	get_input()
	#velocity = move_and_slide(velocity)


func check_move_shape():
	if last_steps.size()>=save_step_count:
		last_steps.pop_front()
	last_steps.push_back(position_index)
	#print(last_steps)
	if last_steps.size() >= 5:
		var last_index = last_steps.size()-1
		if last_steps[last_index] == last_steps[last_index-4] and last_steps[last_index]!=last_steps[last_index-1] and last_steps[last_index]!=last_steps[last_index-2]and last_steps[last_index]!=last_steps[last_index-3]:
			Events.emit_signal("test_quest","spin",{"monkey_position_index":position_index})


func get_collider(dir):
	raycast.cast_to = dir*tile_size
	#..is this stupid or I'm stupid
	raycast.force_raycast_update()
	#print(raycast.cast_to)
	var collider = raycast.get_collider()
	#print(collider)
	return collider

func move(dir):
	if not get_collider(dir):
		if Util.is_in_border(Util.get_player_position_index()+dir):
			is_moving_waiting = true
			$Timer.start()
			
			position_index+=dir
			position = Util.index_to_position(position_index)
			check_move_shape()
			Events.emit_signal("test_quest","come_close",{"monkey_position_index":position_index})

func do_damage(damage = 1):
	is_hiited = true
	ResourceManager.do_damage()
	animation.current_animation = "hitted"
	animation.play()
	yield(animation,"animation_finished")
	is_hiited = false

func pick_up(item):
	item.picked_up(true)
	Util.reparent(item,self)
	item.position = hold_item_position.position
	holding_item = item
	
func drop_down(item,dir):
	Util.reparent(item,Util.tilemap)
	#set position
	item.position = Util.index_to_position((Util.get_player_position_index()+dir))
	#I dont understand but not having this it would collide with my poor player
	yield(get_tree().create_timer(0.1), "timeout")

	item.picked_up(false)
	holding_item = null

func interact(dir):
	var facing_item = get_collider(dir)
	if ResourceManager.can_plus(facing_item,holding_item):
		ResourceManager.plus_coin(facing_item,holding_item)
		if holding_item.is_destoryed:
			holding_item  = null
	else:
		if holding_item:
			yield(drop_down(holding_item, dir),"completed")
		
		if facing_item:
			pick_up(facing_item)
	print("holding_item ",holding_item)
	if holding_item:
		sprite.frame = 1
	else:
		sprite.frame = 0

func _on_Timer_timeout():
	is_moving_waiting = false
