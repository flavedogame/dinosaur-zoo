extends Node

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var tile_size = 16

var visitor_dialog_size = Vector2(400,210)
var normal_dialog_size = Vector2(900,210)


var screen_size = Vector2(1024*3/4,600*3/4)
var outside_rail_length = 4
var outside_rail_length_side = 3
var inborder_x_range = [outside_rail_length+1, screen_size.x/tile_size - outside_rail_length-1]
var inborder_y_range = [outside_rail_length+1, screen_size.y/tile_size - 1]


var core_game_manager
var Zoo
var tilemap
var Hud
var visitor_dialog_parent
var visitor_quest_parent
var visitor_warning_parent
var Player
var game_root

var DIR = [Vector2.RIGHT,Vector2.LEFT,Vector2.UP,Vector2.DOWN]

func reparent(child: Node, new_parent: Node):
	var old_parent = child.get_parent()
	old_parent.remove_child(child)
	new_parent.add_child(child)

func get_player_position_index():
	var player_position = Player.position
	return position_to_index(player_position)
	
func get_player_position():
	var player_position = Player.position
	return player_position

func _ready():
	rng.randomize()

func index_to_position(index):
	return index*16
	
func is_in_border(index):
	return index.x>=inborder_x_range[0] and index.x<=inborder_x_range[1] \
		and index.y>=inborder_y_range[0] and index.y<=inborder_y_range[1]
		
func position_to_position(position):
	var index = position_to_index(position)
	return index_to_position(index)

func position_move(character,dir):
	var position = character.position
	var index = position_to_index(position)
	index+=dir
	character.position = index_to_position(index)
	
func position_to_index(index):
	var res = Vector2(floor(index.x/16),floor(index.y/16))
	return res
	
func random_split_value_in_portion(value,count):
	var res = []
	while count>1 and value>0:
		var v = rng.randi_range(1,value)
		res.append(v)
		value-=v
		count-=1
	res.append(value)
	return res

func sum_array(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum

func randomi_size_with_invalid_positions(size,invalid_position, loop_count = 100):
	for i in range(loop_count):
		var res = Util.rng.randi_range(0,size)
		if not (invalid_position.get(res,false)):
			return res
		else:
			pass
			#print("duplicated")
	return -1
	
func randomf_range_array(array):
	return rng.randf_range(array[0],array[1])
	
func randomi_range_array(array):
	return rng.randi_range(array[0],array[1])

func randomi_array_size(array):
	return rng.randi_range(0,array.size()-1)
	
func random_element_array(array):
	var i = rng.randi_range(0,array.size()-1)
	return array[i]

func random_distribution_array(array):
	var total_count = sum_array(array)
	var random_value = rng.randi_range(0,total_count)
	var increading_count = 0
	for i in array.size():
		increading_count+=array[i]
		if random_value<=increading_count:
			return i
	push_error("random array didn't return correctly")
	return 0

func clear_all_children(node):
	for child in node.get_children():
		child.queue_free()

func load_json(file_path):
	var file = File.new()
	var error = file.open(file_path, File.READ)
	if error != OK:
		printerr("Couldn't open file for read: %s, error code: %s." % [file_path, error])
		return
	var json = file.get_as_text()
	var res = JSON.parse(json).result
	error = JSON.parse(json).error
	if error != OK:
		print(JSON.parse(json).error_string)
	file.close()
	return res
