extends Node


var level_infos
var current_level = 0

var level_folder = "res://resources/level"

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
	
func get_level(level):
	current_level=level
