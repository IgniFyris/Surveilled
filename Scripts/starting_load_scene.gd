extends Control

const STARTING_MENU = preload("uid://dywjhbiic3bpi")
@onready var splash_screen_warning: RichTextLabel = $SplashScreenWarning

func _ready() -> void:
	var tw = create_tween().tween_property(splash_screen_warning, "modulate:a", 1, 1)
	
	await tw.finished
	await get_tree().create_timer(3.0).timeout
	
	tw = create_tween().tween_property(splash_screen_warning, "modulate:a", 0, 1)
	
	await tw.finished
	
	get_tree().change_scene_to_packed(STARTING_MENU)
