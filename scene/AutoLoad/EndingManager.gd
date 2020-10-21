extends Node

var ending_view = preload("res://scene/UI/Ending.tscn")

func switch_ending(ending_name):
	var ending_view_instance = ending_view.instance()
	ending_view_instance.init(ending_name)
	Util.clear_all_children(Util.game_root)
	Util.game_root.add_child(ending_view_instance)
	

func on_health_depleted():
	switch_ending("health_depleted")

func on_get_max_level():
	switch_ending("get_max_level")

func _ready():
	Events.connect("health_depleted",self,"on_health_depleted")
	Events.connect("get_max_level",self,"on_get_max_level")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
