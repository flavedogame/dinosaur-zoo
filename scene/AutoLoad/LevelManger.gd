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
	var res = level_infos[current_level].duplicate()
	if DebugSetting.skip_main_game:
		res.level_length = 1
	return res

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
	Events.emit_signal("save_globally")

func load_saved_data(data):
	current_level = data["day"]-2
	ResourceManager.current_health = data["health"]
	ResourceManager.current_earning = data["earning"]
	ResourceManager.current_reputation = data["reputation"]


var Level_SAVE_KEY = "levels"

func save(saved_game: Resource):
	saved_game.data[Level_SAVE_KEY] = saved_data
	
func load(saved_game: Resource):
	if not saved_game.data.has(Level_SAVE_KEY):
		saved_data = []
	else:
		saved_data = saved_game.data[Level_SAVE_KEY]
