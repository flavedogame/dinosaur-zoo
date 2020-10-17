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
	
func occupy_position(coin):
	var player_position = Util.get_player_position()
	var res = {player_position:coin}
	return res

func start_warning(dinosaur):
	var positions = occupy_position(1)
	var warning_list:Array = []
	var total_coin_value = 1
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
	var reputation = 1
	ResourceManager.add_reputation(reputation)
	
	throw_coin(dinosaur,coin)
	
	ResourceManager.add_coin(total_coin_value)
