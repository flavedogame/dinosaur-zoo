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
var doing_things_rate = [0,100,0]
enum THINGS_TODO {chitchat,quest,leave,wait,none}
var current_doing = THINGS_TODO.none

var current_dialog
var selected_quest

# Called when the node enters the scene tree for the first time.
func _ready():
	if face == 1:
		sprite.scale.x = -sprite.scale.x
		mouth.position.x = -mouth.position.x
		
func leave():
	current_doing = THINGS_TODO.leave	
	Events.emit_signal("dinosaur_left",position_index)	
	print("current_dialog ",current_dialog)
	if current_dialog:
		current_dialog.queue_free()
		current_dialog = null

func show_succeed_quest_dialog():
	
	var succeed_quest_dialog = QuestManager.select_succeed_quest_dialog(selected_quest)
	current_dialog = DialogManager.select_dialog(self,succeed_quest_dialog)
	#print(current_dialog)
	yield(show_dialog(current_dialog, Util.visitor_quest_parent),"completed")
	pass
	
func show_failed_quest_dialog():
	var failed_quest_dialog = QuestManager.select_failed_quest_dialog(selected_quest)
	current_dialog = DialogManager.select_dialog(self,failed_quest_dialog)
	print(failed_quest_dialog)
	#print(current_dialog)
	yield(show_dialog(current_dialog, Util.visitor_quest_parent),"completed")
	pass

#todo: queue finish

func finish_quest():
	print("finish quest")
	if current_doing == THINGS_TODO.quest:
		Events.disconnect("test_quest",self,"test_quest")
		current_dialog.queue_free()
		
func finish_quest_dialog():
	
	if current_doing == THINGS_TODO.quest:
		current_doing = THINGS_TODO.none
		leave()

func check_if_position_is_close(quest_args):
	var monkey_position_index = quest_args.monkey_position_index
	var dinosaur_position_index = Util.position_to_index(position)
	var distance = monkey_position_index.distance_to(dinosaur_position_index)
	#print("distance ",distance)
	if distance <= 10:
		return true
	return false



func quest_succeed():
	finish_quest()
	var data = RewardManager.start_warning(self)
	yield(show_succeed_quest_dialog(),"completed")
	finish_quest_dialog()
	RewardManager.offer_reward(self,data)
	
func quest_failed():
	finish_quest()
	var data = RewardManager.start_warning(self)
	yield(show_failed_quest_dialog(),"completed")
	finish_quest_dialog()
	
	RewardManager.offer_reward(self,data)
	print("failed quest")

func test_quest(quest_name, quest_args):
	#print(quest_name," ",quest_args)
	if quest_name == selected_quest.name:
		match quest_name:
			"come_close":
				if check_if_position_is_close(quest_args):
					yield(quest_succeed(),"completed")
			"spin":
				if check_if_position_is_close(quest_args):
					yield(quest_succeed(),"completed")
		

func select_quest():
	selected_quest = QuestManager.select_quest(self)
	
	current_dialog = DialogManager.select_dialog(self,selected_quest)
	#print(current_dialog)
	show_dialog(current_dialog, Util.visitor_quest_parent)
	
	Events.connect("test_quest",self,"test_quest")
	#don't know why use timer here will make queue_free for dialog not work
	#yield(timer, "timeout")
	yield(get_tree().create_timer(quest_waiting_time), "timeout")
	quest_failed()
	print("failed quest")

func select_chitchat():
	var dialog_instance = DialogManager.select_chitchat(self)
	yield(show_dialog(dialog_instance),"completed")
	
	dialog_instance.queue_free()
	leave()
	
func show_dialog(dialog_instance,parent = Util.visitor_dialog_parent):
	parent.add_child(dialog_instance)
	yield(dialog_instance.start_dialog(),"completed")

func select_thing_todo():
	var selected_thing = Util.random_array(doing_things_rate)
	match selected_thing:
		0:
			print("do chitchat")
			current_doing = THINGS_TODO.chitchat
			select_chitchat()
		1:
			print("do quest")
			current_doing = THINGS_TODO.quest
			select_quest()
		2:
			print("leave")
			current_doing = THINGS_TODO.leave

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
				direction = (target_position-position)/walk_time

func dialog_position():
	var result = mouth.get_global_position()
	if face == 0:
		result-=Vector2(Util.visitor_dialog_size.x,0)
	return result

func init_position(_position,_target,_face,_position_index):
	origin_position = Util.index_to_position(_position)
	position = Util.index_to_position(_position)
	
	target_position = Util.index_to_position(_target)
	direction = (target_position-position)/walk_time
	face = _face
	position_index = _position_index

func init(dinosaur_quest_waiting_time, dinosaur_action_interval_range):
	quest_waiting_time = dinosaur_quest_waiting_time
	do_thing_time_range = dinosaur_action_interval_range


func _on_Timer_timeout():
	select_thing_todo()
