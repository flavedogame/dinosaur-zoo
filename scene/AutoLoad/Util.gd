extends Node

var rng:RandomNumberGenerator = RandomNumberGenerator.new()
var tile_size = 16

func _ready():
	rng.randomize()

func index_to_position(index):
	return index*16

func sum_array(array):
	var sum = 0.0
	for element in array:
		 sum += element
	return sum

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
