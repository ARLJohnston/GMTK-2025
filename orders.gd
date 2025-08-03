class_name Orders
extends Node

var orders: Array = []

var next_order_id: int = 0

func add_order(items: Array) -> void:
	var order = {
		"id": next_order_id,
		"items": items.duplicate(true) 
	}
	orders.append(order)
	next_order_id += 1

func remove_order_by_id(order_id: int) -> void:
	for order in orders:
		if order.id == order_id:
			orders.erase(order)
			return

func get_orders() -> Array:
	return orders.duplicate(true) 
	

func print_orders() -> void:
	if orders.is_empty():
		print("No current orders.")
		return
	
	print("=== Current Orders ===")
	for order in orders:
		print("Order ID:", order.id)
		for item in order.items:
			print("  - Item:", str(item.item), "| Amount:", item.amount)
	print("======================")
