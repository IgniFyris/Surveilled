extends Node2D

const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const FOWL_OS_POP_UP = preload("uid://chkats5ngarti")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var fowl_main_program: TextureButton = $FowlMainProgram

var pressed = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _process(_delta: float) -> void:
	mouse_particles.position = get_global_mouse_position()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		pressed = true
		var clickParticles = MOUSE_CLICK_PARTICLES.instantiate()
		clickParticles.global_position = get_global_mouse_position()
		add_child(clickParticles)
		clickParticles.restart()
		await clickParticles.finished
		clickParticles.queue_free()
	else:
		pressed = false

func _on_fowl_main_program_pressed() -> void:
	fowl_main_program.disabled = true
	var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	var osPopUp = FOWL_OS_POP_UP.instantiate()
	add_child(osPopUp)
	osPopUp.position = center
	osPopUp.scale = Vector2(0, 0)
	var tw = create_tween().tween_property(osPopUp, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
	await osPopUp.tree_exited
	fowl_main_program.disabled = false
