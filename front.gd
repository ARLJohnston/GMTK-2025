extends Node

var customer_sprite := "customer-1"

func _on_to_kitchen_pressed() -> void:
	SceneSwitcher.goto_scene("res://kitchen.tscn")
	


func _on_to_order_mini_game_pressed() -> void:
	SceneSwitcher.goto_scene("res://order_mini_game.tscn")
