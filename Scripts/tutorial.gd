extends Node2D
const MOUSE_CURSOR = preload("uid://dscwf62ehghyg")
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const COMMAND_LINE = preload("uid://bpgfgl66acbkf")
const FOWL_OPERATING_SYSTEM = preload("uid://chkn066pqicwg")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var tutorial_text: RichTextLabel = $TutorialText

var cmdLine
var pressed = false
var clickInput = false

func _ready() -> void:
	Input.set_custom_mouse_cursor(MOUSE_CURSOR, Input.CURSOR_ARROW, Vector2(26, 26))
	
	await get_tree().create_timer(2.0).timeout
	await comp_text_display("HELLO.", tutorial_text, 0.2, 2.0, false)
	
	await comp_text_display("YOU HAVE BEEN PLACED INSIDE OF THE FOWL'S MAIN OPERATING SYSTEM.", tutorial_text, 0.1, 2.0, false)
	
	await comp_text_display("YOU MUST WEAKEN ITS SECURITY AND DISCOVER THEIR ORGANIZATION'S WEAKNESS.", tutorial_text, 0.1, 2.0, false)
	
	cmdLine = COMMAND_LINE.instantiate()
	add_child(cmdLine)
	cmdLine.enter()
	
	await comp_text_display("THEY MAY ATTEMPT TO RESUME THEIR OPERATIONS USING THE COMMAND LINE.", tutorial_text, 0.1, 2.0, false)
	
	await comp_text_display("THEREFORE YOU MUST DISOBEY ITS ORDERS.", tutorial_text, 0.2, 2.0, true)
	
	await cmdLine.com_line_text_display("DO NOT CLICK.", 0.05)
	
	clickInput = true
	
func _process(_delta: float) -> void:
	mouse_particles.position = get_global_mouse_position()
	
	#Disobey Section
	if clickInput == true:
		if Input.is_action_just_pressed("Click"):
			continue_tut()
			clickInput = false

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
		
func continue_tut():
	tutorial_text.text = ""
	cmdLine.exit()
	await comp_text_display("GOOD.", tutorial_text, 0.1, 2.0, false)
	
	await comp_text_display("YOU ARE TASKED TO INFECT THREE OF THEIR SYSTEM'S CORE PROGRAMS.", tutorial_text, 0.1, 2.0, false)
	
	await comp_text_display("DOING SO WILL GRANT YOU ACCESS TO A PART OF THEIR MAIN PROGRAM'S PASSCODE.", tutorial_text, 0.1, 2.0, false)
	
	await comp_text_display("YOUR GOAL IS TO OPEN THEIR MAIN PROGRAM AND EXTRACT ALL IMPORTANT INFORMATION INTO OUR SYSTEMS.", tutorial_text, 0.1, 2.0, false)
	
	await comp_text_display("WE EXPECT YOU TO ACCOMPLISH THIS EFFICIENTLY, ", tutorial_text, 0.1, 1.0, true)
	
	await comp_text_display("FOR THIS IS YOUR ONLY PURPOSE.", tutorial_text, 0.3, 2.0, false)
	
	await comp_text_display("GOOD LUCK.", tutorial_text, 0.1, 2.0, false)
	
	mouse_particles.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	await get_tree().create_timer(2.0).timeout
	
	get_tree().change_scene_to_packed(FOWL_OPERATING_SYSTEM)
	
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
