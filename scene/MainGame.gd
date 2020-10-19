extends Control

var zoo = preload("res://scene/Zoo.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func finish_prolog():
	$prolog.queue_free()
	var zoo_instance = zoo.instance()
	add_child(zoo_instance)
	#yield(zoo_instance, "ready")
	yield(get_tree(), 'idle_frame')
	zoo_instance.level_start()
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("finish_prolog",self,"finish_prolog")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
