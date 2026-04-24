extends Node2D

const ENDING = preload("uid://baokcofcyigy6")

@onready var incorrect: Sprite2D = $Incorrect
@onready var password: LineEdit = $Password
@onready var username: LineEdit = $Username

var entered_password : String
var entered_user : String = "FowlSystems"

func _on_enter_pressed() -> void:
	if entered_password == "test" and entered_user == "FowlSystems":
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
