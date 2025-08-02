extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func key_order_generator() -> Array:
	var possible_actions = ["UP","DOWN","LEFT","RIGHT"]
	var order = [0,0,0,0]
	
	for i in range(order.size()):
		order[i] =  possible_actions.pick_random()
	
	return order



func change_sprite_texture(sprite,key):
	var texture = load("res://assets/"+key+".svg")
	sprite.texture = texture
	
	
	
