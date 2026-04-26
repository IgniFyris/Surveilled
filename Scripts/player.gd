extends CharacterBody2D
class_name Player

@onready var down: RayCast2D = $Raycasts/Down
@onready var right: RayCast2D = $Raycasts/Right
@onready var up: RayCast2D = $Raycasts/Up
@onready var left: RayCast2D = $Raycasts/Left
@onready var sprite: Sprite2D = $Sprite2D

var on_cooldown = false

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Down"):
		if down.is_colliding() and not on_cooldown:
			sprite.rotation_degrees = 180
			self.position.y += 64
			set_cooldown()
	elif Input.is_action_just_pressed("Up"):
		if up.is_colliding() and not on_cooldown:
			sprite.rotation_degrees = 0
			self.position.y -= 64
			set_cooldown()
	elif Input.is_action_just_pressed("Left"):
		if left.is_colliding() and not on_cooldown:
			sprite.rotation_degrees = 270
			self.position.x -= 64
			set_cooldown()
	elif Input.is_action_just_pressed("Right"):
		if right.is_colliding() and not on_cooldown:
			sprite.rotation_degrees = 90
			self.position.x += 64
			set_cooldown()

func set_cooldown():
	on_cooldown = true
	await get_tree().create_timer(0.5).timeout
	on_cooldown = false
