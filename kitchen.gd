extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_to_front_from_kitchen_pressed() -> void:
	SceneSwitcher.goto_scene("res://front.tscn")


func _on_to_drinks_from_kitchen_pressed() -> void:
	SceneSwitcher.goto_scene("res://drinks.tscn")


func _on_fryer_button_pressed() -> void:
	SceneSwitcher.goto_scene("res://FryerGame.tscn")


func _on_pretzel_button_pressed() -> void:
	SceneSwitcher.goto_scene("res://pretzel_game.tscn")
