extends Node2D

const PROGRAM_LOAD_SCREEN = preload("uid://bbyvgnoa7o663")
const ENDING = preload("uid://baokcofcyigy6")

@onready var incorrect: Sprite2D = $Incorrect
@onready var password: LineEdit = $Password
@onready var username: LineEdit = $Username

var entered_password : String
var entered_user : String = "FowlSystems"

func _on_enter_pressed() -> void:
	if entered_password == "AMVZCWF" and entered_user == "FowlSystems":
		var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
		var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
		get_parent().add_child(loadScreen)
		loadScreen.position = center
		loadScreen.scale = Vector2(0, 0)
		loadScreen.fowl_os_loading.texture_progress = loadScreen.FOWLOS_PROGRESS
		loadScreen.fowl_os_loading.texture_under = loadScreen.FOWLOS_PROGRESS_UNDER
		loadScreen.text_change()
		create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		await loadScreen.fill_up()
		get_tree().change_scene_to_packed(ENDING)
	else:
		incorrect.visible = true

func _on_cancel_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _on_password_text_changed(new_text: String) -> void:
	incorrect.visible = false
	entered_password = new_text

func _on_username_text_changed(new_text: String) -> void:
	incorrect.visible = false
	entered_user = new_text
