extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_to_kitchen_from_drinks_pressed() -> void:
	SceneSwitcher.goto_scene("res://kitchen.tscn")
	
