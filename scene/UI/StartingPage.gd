extends Control


func _ready():
	MusicManager.play_music("start")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_StartGame_pressed():
	Events.emit_signal("game_start")
