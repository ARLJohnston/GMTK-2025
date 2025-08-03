class_name Order extends Sprite2D

signal order_complete

enum Orderable {
	LATTE,
	CAPPUCCINO,
	MOCHA,
	MACCHIATO,
	DONUT, 
	PRETZEL
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
var label := Label.new()

func add_order(difficulty : int = 2):
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
			
			
			
			
	return text
	#add_child(label)
	

func check_order():
	var order_complete = true

	for item in order:
		if not (Inventory2.inventory.has(item) and Inventory2.inventory[item] >= order[item]):
			return

	for item in order:
		Inventory2.inventory[item] -= order[item]
		if Inventory2.inventory[item] <= 0:
			Inventory2.inventory.erase(item)

	#Score.inc()
	self.queue_free()
	
func return_in_format():  
	
	for item in order.keys():  
		order2.append({"item" : item , "amount" : order[item]}) 
		
	return order2
		


func _on_button_pressed() -> void:
	check_order()
