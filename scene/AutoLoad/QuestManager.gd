extends Node


var normal_list

var quest_folder = "res://resources/quest"
var dialog = preload("res://scene/UI/Dialog.tscn")

func _ready():
	load_chitchat()
	
func load_chitchat():
	var file_path = '%s/%s.json' % [quest_folder, "normal"]
	normal_list = Util.load_json(file_path)

func select_quest(dianosaur):
	var random_i = Util.randomi_array_size(normal_list)
	return normal_list[random_i]



