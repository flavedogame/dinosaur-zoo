extends CanvasLayer

var level_length
onready var time_progress = $ColorRect/HBoxContainer/ColorRect/open_time_progress
onready var health_progress = $ColorRect/HBoxContainer/ColorRect2/health_bar
onready var earning_label = $ColorRect/HBoxContainer/ColorRect3/earning
onready var repuration_label = $ColorRect/HBoxContainer/ColorRect3/reputation

func read_level_info():
	var level_info = LevelManger.get_levle_info()
	level_length = level_info.level_length
	time_progress.max_value = level_length

func on_level_time_change(_time):
	time_progress.value = _time
	
func on_health_change(_health):
	health_progress.value = _health
	
func on_earning_change(_earning):
	earning_label.text = _earning
	
func on_repuration_change(_repuration):
	repuration_label.text = _repuration

func _ready():
	Events.connect("update_current_time",self,"on_level_time_change")
	Events.connect("update_current_health",self,"on_health_change")
	Events.connect("update_current_earning",self,"on_earning_change")
	Events.connect("update_current_reputation",self,"on_repuration_change")



