extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var one_level_button = preload("res://scene/UI/savedLevel.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	LevelManger.save_level_data()
	for data in LevelManger.saved_data:
		var one_level_button_instance = one_level_button.instance()
		one_level_button_instance.init(data)
		$GridContainer.add_child(one_level_button_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	Events.emit_signal("game_end")
