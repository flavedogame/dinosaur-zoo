extends Node


var game_time
var current_earning
var last_earning
var current_population
var last_population
var passed_time
var max_health = 100
var level_started = false
var current_health = max_health



func level_start():
	level_started = true
	passed_time = 0
	
func _process(delta):
	if level_started:
		passed_time+=delta
		Events.emit_signal("update_current_time",passed_time)

func _ready():
	pass # Replace with function body.

