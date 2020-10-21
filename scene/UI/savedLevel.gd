extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var data

func init(_saved_data):
	data = _saved_data
# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = "Day %d   health:%d coins:%d reputation:%d\n   saved at %d/%d/%d %d:%d:%d"%\
	[data.day,data.health,data.earning,data.reputation,data.saved_time.month,data.saved_time.day,data.saved_time.year\
	,data.saved_time.hour,data.saved_time.minute,data.saved_time.second]
#	data["day"] = get_visual_level()
#	data["saved_time"] = OS.get_datetime()
#	data["earning"] = ResourceManager.current_earning
#	data["reputation"] = ResourceManager.current_reputation
	#year, month, day, weekday, dst (Daylight Savings Time), hour, minute, second.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
