extends Node2D

signal clicked

const MOUSE_CURSOR = preload("uid://dscwf62ehghyg")
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const COMMAND_LINE = preload("uid://bpgfgl66acbkf")
const FOWL_OPERATING_SYSTEM = preload("uid://chkn066pqicwg")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var tutorial_text: RichTextLabel = $TutorialText
@onready var continue_indicator: RichTextLabel = $ContinueIndicator

var cmdLine
var pressed = false
var clickInput = false
var nextText

func _ready() -> void:
	Input.set_custom_mouse_cursor(MOUSE_CURSOR, Input.CURSOR_ARROW, Vector2(26, 26))
	
	await get_tree().create_timer(2.0).timeout
	await comp_text_display("HELLO.", tutorial_text, 0.2)
	
	await comp_text_display("YOU HAVE BEEN PLACED INSIDE OF THE FOWL'S MAIN OPERATING SYSTEM.", tutorial_text, 0.1)
	
	await comp_text_display("YOU MUST WEAKEN ITS SECURITY AND DISCOVER THEIR ORGANIZATION'S WEAKNESS.", tutorial_text, 0.1)
	
	cmdLine = COMMAND_LINE.instantiate()
	add_child(cmdLine)
	cmdLine.enter()
	
	await comp_text_display("THEY MAY ATTEMPT TO RESUME THEIR OPERATIONS USING THE COMMAND LINE.", tutorial_text, 0.1)
	
	await comp_text_display("THEREFORE YOU MUST DISOBEY ITS ORDERS.", tutorial_text, 0.2)
	
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
		clicked.emit()
		pressed = true
		var clickParticles = MOUSE_CLICK_PARTICLES.instantiate()
		clickParticles.global_position = get_global_mouse_position()
		add_child(clickParticles)
		clickParticles.restart()
		await clickParticles.finished
		clickParticles.queue_free()
	elif Input.is_action_pressed("Click"):
		clicked.emit()
		pressed = true
	else:
		pressed = false
		
func continue_tut():
	tutorial_text.text = ""
	cmdLine.exit()
	await get_tree().create_timer(0.1).timeout
	
	await comp_text_display("GOOD.", tutorial_text, 0.1)
	
	await comp_text_display("YOU ARE TASKED TO INFECT TWO OF THEIR SYSTEM'S CORE PROGRAMS.", tutorial_text, 0.1)
	
	await comp_text_display("DOING SO WILL GRANT YOU ACCESS TO A PART OF THEIR MAIN PROGRAM'S PASSCODE.", tutorial_text, 0.1)
	
	await comp_text_display("YOUR GOAL IS TO OPEN THEIR MAIN PROGRAM AND EXTRACT ALL IMPORTANT INFORMATION INTO OUR SYSTEMS.", tutorial_text, 0.1)
	
	await comp_text_display("WE EXPECT YOU TO ACCOMPLISH THIS EFFICIENTLY, ", tutorial_text, 0.1)
	
	await comp_text_display("FOR THIS IS YOUR ONLY PURPOSE.", tutorial_text, 0.1)
	
	await comp_text_display("GOOD LUCK.", tutorial_text, 0.1)
	
	mouse_particles.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	
	await get_tree().create_timer(2.0).timeout
	
	get_tree().change_scene_to_packed(FOWL_OPERATING_SYSTEM)
	
func comp_text_display(comp_text : String, comp_text_container : RichTextLabel, speed : float):
	continue_indicator.visible = true
	continue_indicator.text = "[i] Click to Skip [/i]"
	Sfx.blrrr.play()
	var text_array = comp_text.rsplit()
	
	for character in text_array:
		comp_text_container.text = comp_text_container.text + character
		if pressed == true:
			comp_text_container.text = comp_text
			break
		elif pressed == false:
			var frames = 0
			while frames < (speed*60):
				if pressed == true:
					comp_text_container.text = comp_text
					break
				await get_tree().physics_frame
				frames+=1
	
	continue_indicator.text = "[i] Click to Continue [/i]"
		
	Sfx.blrrr.stop()
	await clicked
	await get_tree().create_timer(0.1).timeout
	comp_text_container.text = ""
	continue_indicator.visible = false
