class_name InventoryItem extends Node 

var amount : int 
var item : Order.Orderable

func _init(_amount : int, _item : Order.Orderable) -> void:   
	amount = _amount
	item = _item
	
