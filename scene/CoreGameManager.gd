extends Node2D

var dinosaur_generation_range = [1,2]
var dinosaur_quest_waiting_time = 5
var dinosaur_action_interval_range = [0,1]
var level_max_dinosaur = 10
var level_length = 30

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
var dianosaur_invalid_position = {}

var task_type

var dinosaur = preload("res://scene/Object/Dinosaur.tscn")

onready var timer = $Timer
onready var dialogs = $dialogs
onready var quest_dialogs = $quest_dialogs

func read_level_info():
	var level_info = LevelManger.get_levle_info()
	level_length = level_info.level_length
	dinosaur_generation_range = level_info.dinosaur_generation_range
	dinosaur_quest_waiting_time = level_info.dinosaur_quest_waiting_time
	dinosaur_action_interval_range = level_info.dinosaur_action_interval_range
	level_max_dinosaur = level_info.level_max_dinosaur
	set_generate_timer()

func _ready():
	MusicManager.play_music("level_game")
	Util.core_game_manager = self
	Events.connect("dinosaur_left",self,"on_dinosaur_left")
	read_level_info()
	ResourceManager.level_start()
	

func set_dinosaur_position(dinosaur_instance):
	var top_count = top_position_x_range[1]- top_position_x_range[0]+1
	var side_count = side_position_y_range[1]- side_position_y_range[0]+1
	var total_count = top_count+side_count*2
	var random_position = Util.randomi_size_with_invalid_positions(total_count,dianosaur_invalid_position)
	if random_position <0:
		return
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
	
	dianosaur_invalid_position[random_position] = true
	dinosaur_instance.init_position(d_origin,d_position,d_face,random_position)

func on_dinosaur_left(position_index):
	dianosaur_invalid_position.erase(position_index)

func set_generate_timer():
	timer.wait_time = Util.randomf_range_array(dinosaur_generation_range)

func _on_Timer_timeout():
	if dianosaur_invalid_position.size() < level_max_dinosaur:
		var dinosaur_instance = dinosaur.instance()
		dinosaur_instance.init(dinosaur_quest_waiting_time, dinosaur_action_interval_range)
		set_dinosaur_position(dinosaur_instance)
		add_child(dinosaur_instance)
	set_generate_timer()
