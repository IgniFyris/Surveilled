extends Node2D

const MOUSE_CURSOR = preload("uid://dscwf62ehghyg")
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const FOWL_OPERATING_SYSTEM = preload("uid://chkn066pqicwg")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var tutorial_text: RichTextLabel = $TutorialText

var cmdLine
var pressed = false
var clickInput = false

func _ready() -> void:
	var username
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	else:
		username = "FOX"
	Input.set_custom_mouse_cursor(MOUSE_CURSOR, Input.CURSOR_ARROW, Vector2(26, 26))
	
	await get_tree().create_timer(2.0).timeout
	await comp_text_display("ISN'T THAT RIGHT,", tutorial_text, 0.2, 2.0, false)
	
	mouse_particles.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	await comp_text_display(username.to_upper() + "?", tutorial_text, 0.5, 2.0, true)
	
	#insert eye opening animation and end to game here
	
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
	
func comp_text_display(comp_text : String, comp_text_container : RichTextLabel, speed : float, wait_time : float, sustain : bool):
	var text_array = comp_text.rsplit()
	
	for character in text_array:
		comp_text_container.text = comp_text_container.text + character
		if pressed == true:
			await get_tree().create_timer(speed/2).timeout
		elif pressed == false:
			await get_tree().create_timer(speed).timeout
		
	await get_tree().create_timer(wait_time).timeout
	
	if sustain == false:
		comp_text_container.text = ""
