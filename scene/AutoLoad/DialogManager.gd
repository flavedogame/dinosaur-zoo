extends Node

var chitchat_list

var dialog_folder = "res://resources/dialog/"
var dialog = preload("res://scene/UI/Dialog.tscn")

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

func select_chitchat(dianosaur):
	var dialog_position = dianosaur.dialog_position()
	var random_i = Util.randomi_array_size(chitchat_list)
	show_chitchat(dialog_position, chitchat_list[random_i])

func show_chitchat(dialog_position, chat):
	var dialog_instance = dialog.instance()
	dialog_instance.init(dialog_position, chat)
	var core_game_manager = Util.core_game_manager
	core_game_manager.add_child(dialog_instance)
