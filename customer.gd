extends Sprite2D

func _ready() -> void:
	self.texture = load("res://assets/customer-"+str(randi() % 2 + 1)+".png")
