extends Node2D

onready var sprite = $Sprite
onready var timer = $Timer
onready var mouth = $mouth

var quest_waiting_time
var origin_position
var target_position
var direction
var walk_time = 0.1
var face
var position_index
var arrived = false

var do_thing_time_range = [0,1]
var doing_things_rate = [100,0,0]
enum THINGS_TODO {chitchat,quest,leave,wait,none}
var current_doing = THINGS_TODO.none

var selected_chitchat

# Called when the node enters the scene tree for the first time.
func _ready():
	if face == 1:
		sprite.scale.x = -sprite.scale.x
		mouth.position.x = -mouth.position.x
		
func leave():
	current_doing = THINGS_TODO.leave	
	Events.emit_signal("dinosaur_left",position_index)	

func select_chitchat():
	yield(DialogManager.select_chitchat(self),"completed")
	leave()
	

func select_thing_todo():
	var selected_thing = Util.random_array(doing_things_rate)
	match selected_thing:
		0:
			print("do chitchat")
			current_doing = THINGS_TODO.chitchat
			select_chitchat()
		1:
			print("do quest")
		2:
			print("leave")

func set_waiting_time():
	var wait_time = Util.randomf_range_array(do_thing_time_range)
	timer.wait_time = wait_time
	timer.start()
#todo: bug, if you click on close button, the time still pass? or is it just walk time too short?
func _process(delta):
	if not arrived:
		if direction:
			if (target_position-position).dot(direction)<0:
				arrived = true
				if current_doing == THINGS_TODO.leave:
					queue_free()
			else:
				position += delta * direction
	else:
		match current_doing:
			THINGS_TODO.wait:
				pass
			THINGS_TODO.none:
				set_waiting_time()
				current_doing = THINGS_TODO.wait
			THINGS_TODO.leave:
				arrived = false
				target_position = origin_position

func dialog_position():
	var result = position + mouth.position
	if face == 0:
		result-=Vector2(140,0)
	return result

func init_position(_position,_target,_face,_position_index):
	origin_position = _position
	position = _position
	target_position = _target
	direction = (target_position-position)/walk_time
	face = _face
	position_index = _position_index

func init(_waiting_time):
	quest_waiting_time = _waiting_time


func _on_Timer_timeout():
	select_thing_todo()
