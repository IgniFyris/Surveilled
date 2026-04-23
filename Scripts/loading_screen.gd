extends Node2D

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	self.modulate.a = 1
	
	var tw = create_tween().tween_property(self, "modulate:a", 0, 1).set_ease(Tween.EASE_IN_OUT)
	await tw.finished
	
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CONFINED)
