extends Node2D
const MOUSE_CURSOR = preload("uid://dscwf62ehghyg")
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
@onready var mouse_particles: CPUParticles2D = $MouseParticles

func _ready() -> void:
	Input.set_custom_mouse_cursor(MOUSE_CURSOR, Input.CURSOR_ARROW, Vector2(26, 26))

func _process(_delta: float) -> void:
	mouse_particles.position = get_global_mouse_position() 

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		var clickParticles = MOUSE_CLICK_PARTICLES.instantiate()
		clickParticles.global_position = get_global_mouse_position()
		add_child(clickParticles)
		clickParticles.restart()
		print(get_global_mouse_position())
		await clickParticles.finished
		clickParticles.queue_free()
		
