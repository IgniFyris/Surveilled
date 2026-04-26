extends Node2D
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const COMMAND_LINE = preload("uid://bpgfgl66acbkf")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var hurt_flash: ColorRect = $HurtFlash
@onready var connections_text: RichTextLabel = $ConnectionsText

var pressed = false
var cmdLine

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(false)
	set_process(false)
	await comp_text_display("[FOWL.OS CONNECTIONS SECTOR]", connections_text, 0.08, 2.0, true)
	await comp_text_display("
INFECT ALL NODES", connections_text, 0.08, 2.0, true)
	await comp_text_display("
'WASD' TO MOVE", connections_text, 0.08, 2.0, false)
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	set_process(true)
	
	cmdLine = COMMAND_LINE.instantiate()
	add_child(cmdLine)
	cmdLine.enter()

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
