extends Node

var current_scene = null

func _ready() -> void:
	var root = get_tree().root
	
	current_scene = root.get_child(-1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	

func goto_scene(path):
	#defer the scene change till the end of the frame to stop engine problems
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	current_scene.free()
	
	var new_scene = ResourceLoader.load(path)
	
	current_scene = new_scene.instantiate()
	get_tree().root.add_child(current_scene)
	
