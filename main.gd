extends Node

connect()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneSwitcher.goto_scene("res://kitchen.tscn")
	var order_ticket = get_node("Order")
	order_ticket.order_complete.connect(_on_order_complete)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_order_complete():
	
