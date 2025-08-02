extends Area2D

var dragging = false
var drag_offset = Vector2()

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Check if mouse is over the donut sprite
			var sprite_rect = $Sprite.get_rect()
			var local_mouse_pos = to_local(event.position)
			if sprite_rect.has_point(local_mouse_pos):
				dragging = true
				drag_offset = position - event.position
		else:
			dragging = false

func _process(delta):
	if dragging:
		position = get_global_mouse_position() + drag_offset
