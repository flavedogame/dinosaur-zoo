extends Node


var game_time
var current_earning = 0
var last_earning = 0
var current_population = 0
var last_population = 0
var passed_time = 0
var max_health = 100
var level_started = false
var current_health = max_health


var coin_type = [1,10,100]
var coin_type_list = ["bronze","silver","gold"]


func can_plus(item1,item2):
	if not item1 or not item2:
		return false
	var type1 = item1.type
	var type2 = item2.type
	var coin_type1 = item1.coin_type
	var coin_type2 = item2.coin_type
	if type1 == "coin" and type2 == "coin" and coin_type1 == coin_type2:
		return true
	return false

func plus_coin(coin1,coin2):
	var value1 = coin1.value
	var value2 = coin2.value
	var type = coin1.coin_type
	if value1+value2 >=10:
		coin1.coin_type +=  1
		coin1.value = 1
		coin2.value = value1+value2-10
	else:
		coin1.value = value1+value2
		coin2.value = 0
	coin1.update_visually()
	if coin2.value == 0:
		coin2.destory()
	else:
		coin2.update_visually()
		

func add_coin(_coin):
	current_earning+=_coin
	Events.emit_signal("update_current_earning",current_earning)
	
func add_reputation(_repu):
	current_population+=_repu
	Events.emit_signal("update_current_reputation",current_population)
	
func level_start():
	level_started = true
	passed_time = 0
	last_earning = current_earning
	last_population = current_population
	current_earning = 0
	
	Events.emit_signal("update_current_earning",current_earning)
	Events.emit_signal("update_current_reputation",current_population)
	
func do_damage(damage = 1):
	current_health-=damage
	Events.emit_signal("update_current_health",current_health)
	if current_health<=0:
		Events.emit_signal("health_depleted")
	
func is_level_end():
	var level_info = LevelManger.get_levle_info()
	var level_length = level_info.level_length
	return passed_time>=level_length

func _process(delta):
	if level_started:
		passed_time+=delta
		Events.emit_signal("update_current_time",passed_time)
		
		if is_level_end():
			Events.emit_signal("level_end")
			level_started = false

func _ready():
	pass # Replace with function body.

