extends Node

var order = []
var sprite_order = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	order = key_order_generator()
	sprite_order = [$Key1, $Key2, $Key3, $Key4]
	create_minigame_order()


func _input(event) -> void:
	if order.size() == 0:
		queue_free()
		return
	var key_to_press = order[0]
	# takes the front of order as the key that is to be pressed and then
	# checks if a key is pressed and matches the key to be pressed, removeing that sprite from a list and 
	if event.is_action_pressed("right_key"):
		if key_to_press == "RIGHT" :
			sprite_order.pop_front().hide()
			order.pop_front()
	if event.is_action_pressed("left_key"):
		if key_to_press == "LEFT" :
			sprite_order.pop_front().hide()
			order.pop_front()
	if event.is_action_pressed("up_key"):
		if key_to_press == "UP" :
			sprite_order.pop_front().hide()
			order.pop_front()
	if event.is_action_pressed("down_key"):
		if key_to_press == "DOWN" :
			sprite_order.pop_front().hide()
			order.pop_front()
		

func create_minigame_order():
	
	change_sprite_texture($Key1, order[0])
	change_sprite_texture($Key2, order[1])
	change_sprite_texture($Key3, order[2])
	change_sprite_texture($Key4, order[3])
	

func key_order_generator() -> Array:
	var possible_actions = ["UP","DOWN","LEFT","RIGHT"]
	var order = [0,0,0,0]
	
	for i in range(order.size()):
		order[i] =  possible_actions.pick_random()
	
	return order

func change_sprite_texture(sprite,key):
	var texture = load("res://assets/"+key+".png")
	sprite.texture = texture
