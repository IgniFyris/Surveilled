extends CharacterBody2D
class_name Antivirus
var PLAYER
var speed = 50
var hovering = false

var attacked = false

func _ready() -> void:
	PLAYER = get_parent().get_parent().player
	
func _physics_process(delta: float) -> void:
	if PLAYER:
		var vel = global_position.direction_to(PLAYER.global_position)
		move_and_collide(vel * speed * delta)

func _input(_event: InputEvent) -> void:
	if hovering:
		if Input.is_action_just_pressed("Click"):
			queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player and not attacked:
		Sfx.boom.play()
		attacked = true
		get_parent().get_parent().hurt()
		queue_free()

func _on_color_rect_mouse_entered() -> void:
	hovering = true

func _on_color_rect_mouse_exited() -> void:
	hovering = false
