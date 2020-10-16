extends Node

var coin_scene = preload("res://scene/Object/coin.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func throw_coin(dinosaur,coin):
	#we only throw one now
	#target is player
	
	var player_position = Util.get_player_position()
	var coin_instance = coin_scene.instance()
	coin_instance.init(dinosaur.position,player_position,coin)
	print(player_position)
	Util.tilemap.add_child(coin_instance)
	pass

func offer_reward(dinosaur):
	var coin = 1
	var reputation = 1
	ResourceManager.add_reputation(reputation)
	
	throw_coin(dinosaur,coin)
	
	ResourceManager.add_coin(coin)
