extends Node


var game_time
var current_earning = 0
var last_earning
var current_population = 0
var last_population
var passed_time
var max_health = 100
var level_started = false
var current_health = max_health

func add_coin(_coin):
	current_earning+=_coin
	Events.emit_signal("update_current_coin",passed_time)
	
func add_reputation(_repu):
	current_population+=_repu
	Events.emit_signal("update_current_reputation",passed_time)
	
func level_start():
	level_started = true
	passed_time = 0
	current_earning = 0
	current_population = 0
	
func do_damage(damage = 1):
	current_health-=damage
	Events.emit_signal("update_current_health",current_health)
	
func _process(delta):
	if level_started:
		passed_time+=delta
		Events.emit_signal("update_current_time",passed_time)

func _ready():
	pass # Replace with function body.

