extends Node

@onready var inventory_container: VBoxContainer = $VBoxContainer 


func _ready() -> void:
	update_inventory_display()  
	
	
	$OrderSprite.hide() 
	$OrderLabel.hide()

func _process(delta: float) -> void:
	if SceneSwitcher.justExitedOrderminigame():
		#var scene = load("res://order.tscn")
		#var a = scene.instantiate()
		#add_child(a) 
		var text = Order2.add_order(3)  
		print("there is new order")
		$OrderLabel.modulate = Color.BLACK
		$OrderLabel.text = text 
		$OrderSprite.show() 
		$OrderLabel.show()
		
		update_inventory_display()

func update_inventory_display() -> void:
	for child in inventory_container.get_children():
		child.queue_free()

	var current_inventory = Inventory2.inventory

	# Iterate through every possible item in the Orderable enum
	for item_enum in Order.Orderable.values():
		var item_name = Order.Orderable.keys()[item_enum]
		var amount = 0
		
		# Check if the item exists in the actual inventory and get its amount
		if current_inventory.has(item_enum):
			amount = current_inventory[item_enum]

		var inventory_item_instance = Label.new()
		inventory_item_instance.text = "%s: %d" % [item_name, amount]
		inventory_container.add_child(inventory_item_instance)

func _on_to_kitchen_pressed() -> void:
	SceneSwitcher.goto_scene("res://kitchen.tscn")

func _on_to_order_mini_game_pressed() -> void:
	SceneSwitcher.goto_scene("res://order_mini_game.tscn")
