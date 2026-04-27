extends Node2D

const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const COMMAND_LINE = preload("uid://bpgfgl66acbkf")
const FOLDERS = preload("uid://ddpqcx5on4mwj")
const ENDING_INDICATOR = preload("uid://dtqk5xa41tlcm")
const PROGRAM_LOAD_SCREEN = preload("uid://bbyvgnoa7o663")
const FOWL_DOWNLOADS = preload("uid://ceoqbli1r6u2d")
var FOWL_OPERATING_SYSTEM = load("uid://chkn066pqicwg")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var downloads_text: RichTextLabel = $DownloadsText
@onready var flash: ColorRect = $Flash
@onready var hurt_flash: ColorRect = $HurtFlash
@onready var folders: Node2D = $Folders
@onready var correct_counter: RichTextLabel = $CorrectCounter

@onready var change_command_timer: Timer = $ChangeCommandTimer
@onready var spawn_folder_timer: Timer = $SpawnFolderTimer
@onready var chaos_increaser: Timer = $ChaosIncreaser

var pressed = false
var cmdLine
var correctActions = 0
var lives = 3

var ColorOptions = ["RED", "GREEN", "BLUE"]
var ActionOptions = ["DELETE", "UPLOAD"]
var foldersObjArray = []

var adder = 0.2
var spawnFolderAdder = 0.05
var chaosTimeAdder = 1 

func _ready() -> void:
	Music.tense.volume_db = 0
	flash.modulate.a = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(false)
	set_process(false)
	await comp_text_display("[FOWL.OS FILE MANAGEMENT SECTOR]", downloads_text, 0.08, 2.0, true)
	await comp_text_display("
LMB TO DELETE", downloads_text, 0.08, 2.0, true)
	await comp_text_display("
RMB TO UPLOAD", downloads_text, 0.08, 2.0, false)

	Music.tense.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	set_process(true)
	
	cmdLine = COMMAND_LINE.instantiate()
	add_child(cmdLine)
	cmdLine.enter()
	
	choose_random()
	
	await cmdLine.com_line_text_display(GlobalVars.current_action + " THE " + GlobalVars.current_color + " FOLDERS.", 0.05)
	
	create_tween().tween_property(flash, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT)
	
	change_command_timer.start()
	spawn_folder_timer.start()
	chaos_increaser.start()
	
	correct_counter.visible = true
		
func _process(_delta: float) -> void:
	mouse_particles.position = get_global_mouse_position()
	var correctActionsString = str(correctActions)
	correct_counter.text = correctActionsString + "/65"
	
	if correctActions == 65:
		Music.tense.stop()
		Sfx.success.play()
		GlobalVars.DownloadsCompleted = true
		mouse_particles.visible = false
		foldersObjArray.clear()
		if folders.get_child_count() > 0:
			for folder in folders.get_children():
				folder.queue_free()
		cmdLine.com_line.text = ""
		cmdLine.com_line_text_display("PARTIAL PASSCODE GRANTED: 1 - 'AMV'", 0.03)
		set_process(false)
		set_process_input(false)
		change_command_timer.stop()
		spawn_folder_timer.stop()
		chaos_increaser.stop()
		var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
		var endPopUp = ENDING_INDICATOR.instantiate()
		add_child(endPopUp)
		endPopUp.position = center
		endPopUp.scale = Vector2(0, 0)
		create_tween().tween_property(endPopUp, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		await endPopUp.infected_indicator()
		var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
		add_child(loadScreen)
		loadScreen.position = center
		loadScreen.scale = Vector2(0, 0)
		loadScreen.fowl_os_loading.texture_progress = loadScreen.DOWNLOADS_PROGRESS
		loadScreen.fowl_os_loading.texture_under = loadScreen.DOWNLOADS_UNDER
		endPopUp.queue_free()
		create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		loadScreen.text_change()
		await loadScreen.fill_up()
		get_tree().change_scene_to_packed(FOWL_OPERATING_SYSTEM)
	elif lives == 0:
		Music.tense.stop()
		Sfx.detected.play()
		mouse_particles.visible = false
		foldersObjArray.clear()
		if folders.get_child_count() > 0:
			for folder in folders.get_children():
				folder.queue_free()
		cmdLine.com_line.text = ""
		cmdLine.com_line_text_display("FOUND YOU.", 0.1)
		set_process(false)
		set_process_input(false)
		change_command_timer.stop()
		spawn_folder_timer.stop()
		chaos_increaser.stop()
		var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
		var endPopUp = ENDING_INDICATOR.instantiate()
		add_child(endPopUp)
		endPopUp.position = center
		endPopUp.scale = Vector2(0, 0)
		create_tween().tween_property(endPopUp, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		await endPopUp.detected_indicator()
		var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
		add_child(loadScreen)
		loadScreen.position = center
		loadScreen.scale = Vector2(0, 0)
		loadScreen.fowl_os_loading.texture_progress = loadScreen.DOWNLOADS_PROGRESS
		loadScreen.fowl_os_loading.texture_under = loadScreen.DOWNLOADS_UNDER
		endPopUp.queue_free()
		cmdLine.exit()
		create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		loadScreen.reboot()
		await loadScreen.fill_up()
		get_tree().change_scene_to_packed(FOWL_DOWNLOADS)

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
	Sfx.binary.play()
	var text_array = comp_text.rsplit()
	
	for character in text_array:
		comp_text_container.text = comp_text_container.text + character
		if pressed == true:
			await get_tree().create_timer(speed/2).timeout
		elif pressed == false:
			await get_tree().create_timer(speed).timeout
		
	Sfx.binary.stop()
	await get_tree().create_timer(wait_time).timeout
	
	if sustain == false:
		comp_text_container.text = ""
		
func choose_random():
	GlobalVars.current_action = ActionOptions[randi_range(0, 1)]
	GlobalVars.current_color = ColorOptions[randi_range(0, 2)]
	
func hurt():
	Sfx.hurt.play()
	hurt_flash.modulate.a = 1
	create_tween().tween_property(hurt_flash, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT)

#	Signals
func _on_change_command_timer_timeout() -> void:
	foldersObjArray.clear()
	if folders.get_child_count() > 0:
		for folder in folders.get_children():
			folder.queue_free()
	flash.modulate.a = 1
	Sfx.glitch.play()
	create_tween().tween_property(flash, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT)
	cmdLine.com_line.text = ""
	choose_random()
	await cmdLine.com_line_text_display(GlobalVars.current_action + " THE " + GlobalVars.current_color + " FOLDERS.", 0.05)

func _on_spawn_folder_timer_timeout() -> void:
	var attempt = 0
	var entered = false
	while not entered and attempt < 50:
		var folder_pos_x = get_viewport_rect().size.x/10 * randi_range(1, 9)
		var folder_pos_y = get_viewport_rect().size.y/10 * randi_range(1, 9)
		var folderPos = Vector2(folder_pos_x, folder_pos_y)
		if foldersObjArray.is_empty() == false:
			var samePos = false
			for i in foldersObjArray:
				if folderPos == i:
					samePos = true
					break
					
			if samePos == false:
				var foldersObj = FOLDERS.instantiate()
				folders.add_child(foldersObj)
				foldersObj.position = folderPos
				foldersObjArray.append(folderPos)
				entered = true
				break
		else:
			var foldersObj = FOLDERS.instantiate()
			folders.add_child(foldersObj)
			foldersObj.position = folderPos
			foldersObjArray.append(foldersObj.position)
			entered = true
			break
		
		attempt += 1

func _on_chaos_increaser_timeout() -> void:
	if not change_command_timer.wait_time < 3.3:
		change_command_timer.wait_time -= (0.5 + adder)
	if not spawn_folder_timer.wait_time < 0.3:
		spawn_folder_timer.wait_time -= (0.05 + spawnFolderAdder)
	adder += 0.2
	chaos_increaser.wait_time -= 2 - chaosTimeAdder
	chaosTimeAdder += 1
	spawnFolderAdder += 0.01
	chaos_increaser.start()
