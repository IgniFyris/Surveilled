extends Node2D

@onready var starting_menu_bg: Sprite2D = $StartingMenuBg
@onready var buttons: Node2D = $Buttons
@onready var loading_screen: Node2D = $LoadingScreen
@onready var invitation: TextureButton = $Buttons/Invitation

const HACK_SCREEN = preload("uid://duhtkoemv8ov0")

var center

func _ready() -> void:
	center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	Input.warp_mouse(center)
	
func _process(_delta: float) -> void:
	var offset = center - get_global_mouse_position() 
	print(offset)

	create_tween().tween_property(starting_menu_bg, "global_position", (offset * 0.02) + Vector2(600, 400), 1)
	create_tween().tween_property(buttons, "global_position", offset * 0.07, 1)

func _on_invitation_pressed() -> void:
	invitation.disabled = true
	loading_screen.modulate.a = 1
	
	await get_tree().create_timer(2.0).timeout
	
	get_tree().change_scene_to_packed(HACK_SCREEN)
