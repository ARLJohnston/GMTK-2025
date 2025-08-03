class_name Order extends Sprite2D

signal order_complete

enum Orderable {
	LATTE,
	CAPPUCCINO,
	MOCHA,
	MACCHIATO,
	DONUT,
} 

const neons := [
	Color(1.0, 0.0, 0.0),  # Neon Red
	Color(0.0, 1.0, 0.0),  # Neon Green
	Color(0.0, 0.0, 1.0),  # Neon Blue
	Color(1.0, 1.0, 0.0),  # Neon Yellow
	Color(1.0, 0.5, 0.0),  # Neon Orange
	Color(0.5, 0.0, 0.5),  # Neon Purple
	Color(0.0, 1.0, 1.0),  # Neon Cyan
	Color(1.0, 0.0, 1.0),  # Neon Magenta
	Color(0.5, 1.0, 0.5),  # Neon Light Green
	Color(1.0, 0.5, 1.0),  # Neon Light Pink
]

var order := {} 
var order2 = []

func _init(difficulty: int = 3):
	for o in Orderable.keys():
		order[o] = 0
		
	for i in range(difficulty):
		var item = Orderable.keys()[randi() % Orderable.keys().size()]
		order[item] += 1   	
		
	self_modulate = neons[randi()%neons.size()]
	var text := "Order:"
	for o in order.keys():
		if order[o] == 1:
			text += "\n\t- " + o
		if order[o] > 1:
			text += "\n\t- %d %ss" % [order[o], o]
			
	var label := Label.new()
	label.position = Vector2(50, 10)
	label.modulate = Color.BLACK
	label.text = text
	add_child(label)

func check_order() -> Array:
	var inventory = Inventory2.inventory.duplicate()
	var order_complete = true

	for pair in order:
		var item = pair[0]
		var amount = pair[1]

		if not Inventory2._has_in_inventory(item, amount):
			return [false, inventory]

		inventory[item] -= amount
		if inventory[item] <= 0:
			inventory.erase(item)

	order_complete.emit()
	self.queue_free()
	return [true, inventory] 
	
	
func return_in_format():  
	
	for item in order.keys():  
		order2.append({"item" : item , "amount" : order[item]}) 
		
	return order2
		


func _on_button_pressed() -> void:
	check_order()
