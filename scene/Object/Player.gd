extends Area2D

onready var raycast = $RayCast2D
onready var animation = $AnimationPlayer
onready var hold_item_position = $hold_item_position
onready var hold_item_position_next = $hold_item_position_next
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

var holding_items = []

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

func get_holding_value():
	var res = 0
	for i in holding_items:
		res+=i.get_value()
	return res

func is_holding_value(value):
	return get_holding_value() == value
		

func has_made_a_circle():
	
	if last_steps.size() >= 5:
		var last_index = last_steps.size()-1
		if last_steps[last_index] == last_steps[last_index-4] and last_steps[last_index]!=last_steps[last_index-1] and last_steps[last_index]!=last_steps[last_index-2]and last_steps[last_index]!=last_steps[last_index-3]:
			return true
	return false

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
			Events.emit_signal("test_quest")

func do_damage(damage = 1):
	is_hiited = true
	ResourceManager.do_damage(damage)
	animation.current_animation = "hitted"
	animation.play()
	yield(animation,"animation_finished")
	is_hiited = false

func pick_up(item):
	#todo: use text or animation to show can't hold
	#todo: hmm this might cause player get stuck somewhere..
	if holding_items.size()<=10:
		item.picked_up(true)
		Util.reparent(item,self)
		item.position = hold_item_position.position + (hold_item_position_next.position-hold_item_position.position)*holding_items.size()
		holding_items.append(item)
	
func drop_down(item,dir):
	Util.reparent(item,Util.tilemap)
	#set position
	item.position = Util.index_to_position((Util.get_player_position_index()+dir))
	#I dont understand but not having this it would collide with my poor player
	yield(get_tree().create_timer(0.1), "timeout")

	item.picked_up(false)
	#holding_item = null

func interact(dir):
	var facing_item = get_collider(dir)
	if ResourceManager.can_plus(facing_item,holding_items.back()):
		ResourceManager.plus_coin(holding_items.back(),facing_item)
		
#		if holding_item.is_destoryed:
#			holding_item  = null
	else:
#		if holding_item:
#			yield(drop_down(holding_item, dir),"completed")
		
		if facing_item:
			pick_up(facing_item)
		else:
			if holding_items.size()>0:
				var top_item = holding_items.back()
				yield(drop_down(top_item, dir),"completed")
				holding_items.pop_back()
	print("holding_items ",holding_items)
	if holding_items.size()>0:
		sprite.frame = 1
	else:
		sprite.frame = 0

func _on_Timer_timeout():
	is_moving_waiting = false
