extends Node


var normal_list
var failed_dialogs

var quest_folder = "res://resources/quest"
var dialog = preload("res://scene/UI/Dialog.tscn")


func _ready():
	load_normal_list()
	load_failed()
	
func load_normal_list():
	var file_path = '%s/%s.json' % [quest_folder, "normal"]
	normal_list = Util.load_json(file_path)
	
func load_failed():
	var file_path = '%s/%s.json' % [quest_folder, "failed"]
	failed_dialogs = Util.load_json(file_path)

func generate_plus_quest(value,quest):
	
	var plus_number1 = Util.rng.randi_range(1,value-1)
	var plus_number2 = value-plus_number1
	quest["value"] = value
	quest["placeholder_value"] = "%d plus %d"%[plus_number1,plus_number2]
	
func generate_multi_quest(value,quest):
	pass
	
func select_quest(dinosaur):
#	if dinosaur.has("quest"):
#		pass
#	else:
	var level_quest = LevelManger.get_levle_info().quest
	var random_i = Util.random_distribution_array(level_quest)
	var quest = normal_list[random_i].duplicate()
	
	match quest.name:
		"plus_10":
			var value = Util.rng.randi_range(2,9)
			generate_plus_quest(value,quest)
		"plus_100":
			var value = Util.rng.randi_range(11,99)
			generate_plus_quest(value,quest)
		"plus_1000":
			var value = Util.rng.randi_range(101,999)
			generate_plus_quest(value,quest)
		"multi_100":
			pass
	return quest
			
#	var random_i = Util.randomi_array_size(normal_list)
#	return normal_list[random_i]
	
func select_succeed_quest_dialog(dialog):
	if dialog.has("completed"):
		var completed_dialogs = dialog.completed
		return Util.random_element_array(completed_dialogs)
	pass
	
func select_failed_quest_dialog(dialog):
	if dialog.has("failed"):
		var completed_dialogs = dialog.failed
		return Util.random_element_array(completed_dialogs)
	else:
		return Util.random_element_array(failed_dialogs)
	pass



