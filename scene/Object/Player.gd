extends Area2D

#ref https://kidscancode.org/godot_recipes/2d/grid_movement/
var tile_size = 16
var inputs = {"right": Vector2.RIGHT,
			"left": Vector2.LEFT,
			"up": Vector2.UP,
			"down": Vector2.DOWN}
var save_step_count = 5
var position_index

var last_steps:Array = []

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * Vector2(tile_size/2,0) 
	position_index = Util.position_to_index(position)
	position = Util.index_to_position(position_index)
	
func _unhandled_input(event):
	for dir in inputs.keys():
		if event.is_action_pressed(dir):
			move(dir)

func check_move_shape():
	if last_steps.size()>=save_step_count:
		last_steps.pop_front()
	last_steps.push_back(position_index)
	print(last_steps)
	if last_steps.size() >= 5:
		var last_index = last_steps.size()-1
		if last_steps[last_index] == last_steps[last_index-4] and last_steps[last_index]!=last_steps[last_index-1] and last_steps[last_index]!=last_steps[last_index-2]and last_steps[last_index]!=last_steps[last_index-3]:
			Events.emit_signal("test_quest","spin",{"monkey_position_index":position_index})

func move(dir):
	position_index+=inputs[dir]
	position = Util.index_to_position(position_index)
	check_move_shape()
	Events.emit_signal("test_quest","come_close",{"monkey_position_index":position_index})
