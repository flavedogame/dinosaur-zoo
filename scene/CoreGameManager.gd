extends Node2D

var dinosaur_generation_time = 0.1
var dinosaur_waiting_time = 1

var screen_size = Vector2(1024*3/4,600*3/4)
var outside_rail_length = 4
var outside_rail_length_side = 3
var tile_size = 16
var top_position_x_range = [outside_rail_length, screen_size.x/tile_size - outside_rail_length]
var top_position_y = outside_rail_length
var top_origin_position_y = -1
var side_position_y_range = [outside_rail_length, screen_size.y/tile_size - 1]
var left_position_x = outside_rail_length_side
var left_origin_position_x = -1
var right_position_x = screen_size.x/tile_size - outside_rail_length_side
var right_origin_position_x = screen_size.x/tile_size+1

var task_type

var dinosaur = preload("res://scene/Object/Dinosaur.tscn")

onready var timer = $Timer

func _ready():
	Util.core_game_manager = self

func set_dinosaur_position(dinosaur_instance):
	var top_count = top_position_x_range[1]- top_position_x_range[0]+1
	var side_count = side_position_y_range[1]- side_position_y_range[0]+1
	var total_count = top_count+side_count*2
	var random_position = Util.rng.randi_range(0,total_count)
	var d_position
	var d_origin
	var d_face
	if random_position < top_count: #top visitor
		var random_x =top_position_x_range[0] + random_position
		d_position = Vector2(random_x,top_position_y)
		d_origin = Vector2(random_x,top_origin_position_y)
		d_face = 0 if random_position > top_count/2 else 1
	elif random_position < top_count + side_count: #left visitors
		var random_value = random_position - top_count
		var random_y = side_position_y_range[0] + random_value
		d_position = Vector2(left_position_x,random_y)
		d_origin = Vector2(left_origin_position_x,random_y)
		d_face = 1
	else: #right visitors
		var random_value = random_position - top_count - side_count
		var random_y = side_position_y_range[0] + random_value
		d_position = Vector2(right_position_x,random_y)
		d_origin = Vector2(right_origin_position_x,random_y)
		d_face = 0
	#var random_x = rng.randi_range (top_position_x_range[0], top_position_x_range[1])
	#var d_position = Vector2(random_x,top_position_y)
	
	dinosaur_instance.init_position(Util.index_to_position(d_origin),Util.index_to_position(d_position),d_face)

func _on_Timer_timeout():
	var dinosaur_instance = dinosaur.instance()
	dinosaur_instance.init(dinosaur_waiting_time)
	set_dinosaur_position(dinosaur_instance)
	add_child(dinosaur_instance)
	timer.wait_time = dinosaur_generation_time
