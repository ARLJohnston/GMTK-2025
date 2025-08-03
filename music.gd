extends Node

var asp_node : AudioStreamPlayer = null

func _ready() -> void:
	var asp := AudioStreamPlayer.new()
	asp.stream = load("res://assets/loop.mp3")
	asp.autoplay = true
	asp_node = asp
	add_child(asp)
	
func _process(delta: float) -> void:
	if asp_node:
		if !asp_node.playing:
			asp_node.play()
