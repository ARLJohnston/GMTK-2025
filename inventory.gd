class_name Inventory extends Node

var inventory = {}

func _add_to_inventory(item, amount) -> void:
	if inventory.has(item):
		inventory[item] += amount
	else:
		inventory[item] = amount 
		 
		
func _has_in_inventory(item: Order.Orderable, amount: int = 1) -> bool:
	return inventory.has(item) and inventory[item] >= amount

		
func print_inventory() -> void:  
	for item in inventory.keys(): 
		print(" inventory " , Order.Orderable.keys()[item]) 
		print(inventory[item])
		

func _remove_from_inventory(item, amount) -> void:
	if inventory.has(item):
		inventory[item] -= amount
		if inventory[item] <= 0:
			inventory.erase(item) 
