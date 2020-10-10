extends Node

var chitchat_list

var dialog_folder = "res://resources/dialog/"

func _ready():
	load_chitchat()

func load_json(file_path):
	var file = File.new()
	#var file_path = '%s/%s.json' % [dialogues_folder, id]
	var error = file.open(file_path, File.READ)
	if error != OK:
		printerr("Couldn't open file for read: %s, error code: %s." % [file_path, error])
		return
	var json = file.get_as_text()
	var dialogue = JSON.parse(json).result
	error = JSON.parse(json).error
	if error != OK:
		print(JSON.parse(json).error_string)
	file.close()
	return dialogue

func load_chitchat():
	var file_path = '%s/%s.json' % [dialog_folder, "chitchat"]
	chitchat_list = load_json(file_path)

func select_chitchat():
	var random_i = Util.randomi_array_size(chitchat_list)
	return chitchat_list[random_i]
