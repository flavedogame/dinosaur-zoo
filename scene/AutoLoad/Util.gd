extends Node

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var tile_size = 16

var core_game_manager

func _ready():
	rng.randomize()

func index_to_position(index):
	return index*16
	
func position_to_index(index):
	var res = Vector2(floor(index.x/16),floor(index.y/16))
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

func randomi_array_size(array):
	return rng.randi_range(0,array.size()-1)

func random_array(array):
	var total_count = sum_array(array)
	var random_value = rng.randi_range(0,total_count)
	var increading_count = 0
	for i in array.size():
		increading_count+=array[i]
		if random_value<=increading_count:
			return i
	push_error("random array didn't return correctly")
	return 0


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
