extends Area2D

@export var zone_flavour = "chocolate"

signal donut_dipped(flavour)

func _on_area_entered(area):
	print("Area entered detected! Area name: ", area.name)
	if area.name == "Donut":
		print("Donut detected! Emitting signal with flavour: ", zone_flavour)
		emit_signal("donut_dipped", zone_flavour)
	else:
		print("Not a donut, it's: ", area.name)
