extends Node


var level_infos
var current_level = 0

var level_folder = "res://resources/level"

var saved_data = []

func _ready():
	load_chitchat()
	
func load_chitchat():
	var file_path = '%s/%s.json' % [level_folder, "level"]
	level_infos = Util.load_json(file_path)

func get_levle_info():
	if current_level>= level_infos.size():
		push_error("level %d more than define"%current_level)
	return level_infos[current_level]

func next_level():
	current_level+=1
	if current_level >=level_infos.size():
		Events.emit_signal("get_max_level")
	
func get_visual_level():
	return current_level+1
	
func get_level(level):
	current_level=level

func save_level_data():
	var data = {}
	data["day"] = get_visual_level()
	data["health"] = ResourceManager.current_health
	data["saved_time"] = OS.get_datetime()
	data["earning"] = ResourceManager.current_earning
	data["reputation"] = ResourceManager.current_reputation
	#force overwrite
	if saved_data.size()>current_level:
		saved_data[current_level] = data
	else:
		saved_data.append(data)
