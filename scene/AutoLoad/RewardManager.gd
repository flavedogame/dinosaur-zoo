extends Node

var coin_scene = preload("res://scene/Object/coin.tscn")
var warning_scene = preload("res://scene/UI/warning_rect.tscn")
var warning_occupy = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func throw_coin(dinosaur,coin_data):
	#we only throw one now
	#target is player
	for k in coin_data:
		var coin_instance = coin_scene.instance()
		coin_instance.init(dinosaur.position,k,coin_data[k])
		Util.tilemap.add_child(coin_instance)
	
func split_coin(value_list):
	var res = []
	for value in value_list:
		var divider = 10
		while value>0:
			if value%divider!=0:
				var new_value = value%divider
				res.append(new_value)
				value = value-new_value
			divider *=10
	print("split coin",res)
	return res
	
func occupy_position(coin_and_count):
	var coin_value = coin_and_count[0]
	var coin_count = coin_and_count[1]
	
	var res = Util.random_split_value_in_portion(coin_value,coin_count)
	
	print("split value",res)
	res = split_coin(res)
	var player_position = Util.get_player_position()
	var potential_position = [player_position]
	var current_count = 0
	var res_dict = {}
	while potential_position.size()>0 and current_count<res.size():
		#check if some coin else is using this position
		var current_position = potential_position.front()
		potential_position.pop_front()
		res_dict[current_position] = res[current_count]
		current_count+=1
		#add four neighbours
		for dir in Util.DIR:
			var new_index = Util.position_to_index(current_position) +dir
			if Util.is_in_border( new_index):
				var new_position = Util.index_to_position(new_index)
				potential_position.push_back(new_position)
	print("occupy position ",res_dict)
	return res_dict

func calculate_coin_and_count(dinosaur):
	var level_coin_value = LevelManger.get_levle_info().coin_value
	var level_coin_count = LevelManger.get_levle_info().coin_count
	var coin_value = Util.randomi_range_array(level_coin_value)
	var coin_count = Util.randomi_range_array(level_coin_count)
	return [coin_value,coin_count]
	

func start_warning(dinosaur):
	var calculate_res = calculate_coin_and_count(dinosaur)
	var positions = occupy_position(calculate_res)
	var warning_list:Array = []
	var total_coin_value = calculate_res[0]
	for k in positions:
		var warning_instance = warning_scene.instance()
		warning_instance.init(k)
		warning_list.append(warning_instance)
		Util.tilemap.add_child(warning_instance)
	var res = [positions,warning_list, total_coin_value]
	#print(res)
	return res


func offer_reward(dinosaur,previous_data):
	#release warning tiles
	for i in previous_data[1]:
		i.free()
	#previous_data[1].queue_free()
	var coin = previous_data[0]
	var total_coin_value = previous_data[2]
	#var reputation = 1
	#ResourceManager.add_reputation(reputation)
	
	throw_coin(dinosaur,coin)
	
	ResourceManager.add_coin(total_coin_value)
