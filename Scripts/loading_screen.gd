extends Node2D

func _ready() -> void:
	get_tree().paused = true
	self.modulate.a = 1
	
	var tw = create_tween().tween_property(self, "modulate:a", 0, 1).set_ease(Tween.EASE_IN_OUT)
	await tw.finished
	
	get_tree().paused = false
