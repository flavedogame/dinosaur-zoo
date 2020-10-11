extends Node

var chitchat_list

var dialog_folder = "res://resources/dialog/"
var dialog = preload("res://scene/UI/Dialog.tscn")

func _ready():
	load_chitchat()
	
func load_chitchat():
	var file_path = '%s/%s.json' % [dialog_folder, "chitchat"]
	chitchat_list = Util.load_json(file_path)

func select_chitchat(dianosaur):
	var random_i = Util.randomi_array_size(chitchat_list)
	
	return select_dialog(dianosaur,chitchat_list[random_i])

func select_dialog(dianosaur,chat):
	var is_quest = chat.has("name")
	var dialog_position = dianosaur.dialog_position()
	var dialog_instance = dialog.instance()
	dialog_instance.init(dialog_position, chat,is_quest)
	return dialog_instance
