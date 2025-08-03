extends Node

var score := 0

func inc():
	score += 1
	checkwin()
	
func checkwin():
	if score >= 10:
		SceneSwitcher.goto_scene("res://win.tscn")
