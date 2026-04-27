extends Node2D

signal clicked

const MOUSE_CURSOR = preload("uid://dscwf62ehghyg")
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const FOWL_OPERATING_SYSTEM = preload("uid://chkn066pqicwg")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var tutorial_text: RichTextLabel = $TutorialText
@onready var data_timer: Timer = $DataTimer
@onready var error_text_1: RichTextLabel = $ErrorText1
@onready var error_text_2: RichTextLabel = $ErrorText2
@onready var animation_player: AnimationPlayer = $FinalAnim/AnimationPlayer
@onready var final_anim: Node2D = $FinalAnim
@onready var shader: ColorRect = $Shader
@onready var end_screen: Sprite2D = $EndScreen

var cmdLine
var pressed = false
var clickInput = false
var stop = false
var get_click = false
var nextText

func _ready() -> void:
	Music.finale.play()
	for i in final_anim.get_children():
		if i is not AnimationPlayer:
			i.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Input.set_custom_mouse_cursor(MOUSE_CURSOR, Input.CURSOR_ARROW, Vector2(26, 26))
	
	await get_tree().create_timer(2.0).timeout
	
	await comp_text_display("AUTHORIZATION GRANTED.", tutorial_text, 0.05, 2.0, false, false)
	
	await comp_text_display("PROVIDING NECESSARY DATA", tutorial_text, 0.05, 0, true, nextText)
	
	data_timer.start()
	
	while not data_timer.is_stopped():
		if tutorial_text.text != "PROVIDING NECESSARY DATA...":
			tutorial_text.text = tutorial_text.text + "."
		elif tutorial_text.text == "PROVIDING NECESSARY DATA...":
			tutorial_text.text = "PROVIDING NECESSARY DATA"
		elif data_timer.is_stopped():
			break
	
		await get_tree().create_timer(0.4).timeout
	
	Music.finale.stop()
	tutorial_text.text = "👁️"
	get_click = false
	
	await get_tree().create_timer(3).timeout
	
	Music.buzz.play()
	
	comp_text_display_binary("11110001100111010110100100101001001101101110100111101011100000110111101100100010011010100110011011100001111101010111010101100100100110000100100110100101011100001111000101100100101010110010100001110000111110000100000110010111010110001111101101000100100000100001011110101000010011000001101111011001010000110110011100111010010100111010011001001100001100011010101010101111000010011010100110110101001100101110111001", error_text_1, 0.07, 0, false)
	comp_text_display_binary("11110001100111010110100100101001001101101110100111101011100000110111101100100010011010100110011011100001111101010111010101100100100110000100100110100101011100001111000101100100101010110010100001110000111110000100000110010111010110001111101101000100100000100001011110101000010011000001101111011001010000110110011100111010010100111010011001001100001100011010101010101111000010011010100110110101001100101110111001", error_text_2, 0.07, 0, false)
	
	await get_tree().create_timer(1.5).timeout
	tutorial_text.text = ""
	
	await comp_text_display("WHAT MADE YOU THINK YOU WERE THE HUNTER?", tutorial_text, 0.2, 2.0, false, false)
	
	await comp_text_display("RULEBREAKERS, TRICKSTERS, AND DECEIVERS NEVER GO TRULY UNPUNISHED.", tutorial_text, 0.2, 3.0, false, false)

	await comp_text_display("ISN'T THAT RIGHT,", tutorial_text, 0.2, 2.0, false, false)
	
	stop = true
	
	mouse_particles.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_click = false
	
	var username
	if OS.has_environment("USERNAME"):
		username = OS.get_environment("USERNAME")
	else:
		username = "YOU FILTHY FOX"
		
	Music.buzz.stop()
	
	await comp_text_display(username.to_upper() + "?", tutorial_text, 0.5, 2.0, true, false)
	
	username = ""
	
	animation_player.play("EyeOpen")
	
	await animation_player.animation_finished
	
	await get_tree().create_timer(2.0).timeout
	
	final_anim.visible = false
	tutorial_text.visible = false
	
	await get_tree().create_timer(2.0).timeout
	
	create_tween().tween_property(end_screen, "modulate:a", 1, 0.5).set_ease(Tween.EASE_IN_OUT)
	
func _process(_delta: float) -> void:
	mouse_particles.position = get_global_mouse_position()

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("Click"):
		clicked.emit()
		pressed = true
		if get_click == true:
			var clickParticles = MOUSE_CLICK_PARTICLES.instantiate()
			clickParticles.global_position = get_global_mouse_position()
			add_child(clickParticles)
			clickParticles.restart()
			await clickParticles.finished
			clickParticles.queue_free()
	else:
		pressed = false
	
func comp_text_display(comp_text : String, comp_text_container : RichTextLabel, speed : float, wait_time : float, sustain : bool, prevText):
	Sfx.binary.play()
	var text_array = comp_text.rsplit()
	
	if prevText is not bool:
		comp_text_container.text = prevText
	
	for character in text_array:
		comp_text_container.text = comp_text_container.text + character
		if pressed == true:
			if prevText is not bool:
				comp_text_container.text = prevText + comp_text
			else:
				comp_text_container.text = comp_text
			break
		elif pressed == false:
			var frames = 0
			while frames < (speed*60):
				if pressed == true:
					if prevText is not bool:
						comp_text_container.text = prevText + comp_text
					else:
						comp_text_container.text = comp_text
					break
				await get_tree().physics_frame
				frames+=1
	
	Sfx.binary.stop()
	
	await get_tree().create_timer(wait_time).timeout
	
	if sustain == false:
		nextText = ""
		comp_text_container.text = ""
	else:
		nextText = comp_text_container.text
		
func comp_text_display_binary(error_text : String, error_text_container : RichTextLabel, error_speed : float, error_wait : float, error_sustain : bool):
	Sfx.binary.play()
	var binary_array = error_text.rsplit()
	
	for character in binary_array:
		if stop == false:
			error_text_container.text = error_text_container.text + character
			await get_tree().create_timer(error_speed).timeout
		else:
			error_text_container.text = ""
			return
		
	Sfx.binary.stop()
	await get_tree().create_timer(error_wait).timeout
	
	if error_sustain == false:
		error_text_container.text = ""
