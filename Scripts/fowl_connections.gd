extends Node2D
const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const COMMAND_LINE = preload("uid://bpgfgl66acbkf")
const NODE = preload("uid://ndxe7eglmwwi")
const ENDING = preload("uid://baokcofcyigy6")
const ENDING_INDICATOR = preload("uid://dtqk5xa41tlcm")
const PROGRAM_LOAD_SCREEN = preload("uid://bbyvgnoa7o663")
const FOWL_CONNECTIONS = preload("uid://33u010ucbdw")
var FOWL_OPERATING_SYSTEM = load("uid://chkn066pqicwg")
const ANTIVIRUS = preload("uid://cs1ajlh8idt7c")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var hurt_flash: ColorRect = $Player/CanvasLayer/HurtFlash
@onready var connections_text: RichTextLabel = $ConnectionsText
@onready var player: Player = $Player
@onready var nodes: Node2D = $Nodes
@onready var infected_counter: RichTextLabel = $Player/CanvasLayer/InfectedCounter
@onready var camera_2d: Camera2D = $Player/Camera2D
@onready var canvas_layer: CanvasLayer = $Player/CanvasLayer
@onready var change_command_timer: Timer = $ChangeCommandTimer
@onready var enemy_spawn: Timer = $EnemySpawn
@onready var path_follow_2d: PathFollow2D = $Player/Path2D/PathFollow2D
@onready var marker_2d: Marker2D = $Player/Path2D/PathFollow2D/Marker2D
@onready var antiviruses: Node2D = $Antiviruses

var pressed = false
var cmdLine
var lives = 3
var adder = 0.5
var enemy_time_adder = 0.2

var num_of_nodes : int = 0
var num_of_infected_nodes : int = 0

var ActivityOptions = ["DO NOT ADVANCE" ,"MOVE", "PROCEED"]
var DirectionOptions = ["UP", "DOWN", "LEFT", "RIGHT"]

func _ready() -> void:
	player.visible = false
	camera_2d.enabled = false
	infected_counter.visible = false
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	set_process_input(false)
	set_process(false)
	await comp_text_display("[FOWL.OS CONNECTIONS SECTOR]", connections_text, 0.08, 2.0, true)
	await comp_text_display("
INFECT ALL NODES", connections_text, 0.08, 2.0, true)
	await comp_text_display("
'WASD' TO MOVE", connections_text, 0.08, 2.0, true)
	await comp_text_display("
'LMB' TO DESTROY ANTIVIRUSES", connections_text, 0.08, 2.0, false)
	player.visible = true
	camera_2d.enabled = true
	infected_counter.visible = true
	Music.tenser.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	set_process_input(true)
	set_process(true)
	
	cmdLine = COMMAND_LINE.instantiate()
	canvas_layer.add_child(cmdLine)
	cmdLine.enter()
		
	GlobalVars.current_activity = ActivityOptions.pick_random()
	GlobalVars.current_direction = DirectionOptions.pick_random()
	cmdLine.com_line_text_display(str(GlobalVars.current_activity) + " " + str(GlobalVars.current_direction), 0.05)
	
	change_command_timer.start()
	enemy_spawn.start()
	
	var next_position = player.position

	for i in range(35):
		var node = NODE.instantiate()
		node.position = next_position
		nodes.add_child(node)
		
		await get_tree().physics_frame

		var free_dirs = node.check_free_directions()
		if free_dirs.is_empty():
			var prev_node = node
			while free_dirs.is_empty():
				var random_occupied_direction = ["up", "down", "left", "right"]
				var picked = random_occupied_direction.pick_random()
				var neighbour_node
				match picked:
					"up": neighbour_node = prev_node.up.get_collider()
					"down": neighbour_node = prev_node.down.get_collider()
					"left": neighbour_node = prev_node.left.get_collider()
					"right": neighbour_node = prev_node.right.get_collider()
				free_dirs = neighbour_node.check_free_directions()
				if not free_dirs.is_empty:
					break
				prev_node = neighbour_node
			
		var chosen = free_dirs.pick_random()
		match chosen:
			"up": next_position += Vector2(0, -64)
			"down": next_position += Vector2(0, 64)
			"left": next_position += Vector2(-64, 0)
			"right": next_position += Vector2(64, 0)
	
func _process(_delta: float) -> void:
	mouse_particles.position = get_global_mouse_position()
	infected_counter.text = str(GlobalVars.num_of_infected_nodes) + "/" + str(nodes.get_child_count())
	
	if GlobalVars.num_of_infected_nodes == nodes.get_child_count():
		Music.tenser.stop()
		Sfx.success.play()
		cmdLine.com_line.text = ""
		cmdLine.com_line_text_display("PARTIAL PASSCODE GRANTED: 1 - 'ZCWF'", 0.03)
		for i in antiviruses.get_children():
			i.queue_free()
		change_command_timer.stop()
		enemy_spawn.stop()
		GlobalVars.ConnectionsCompleted = true
		mouse_particles.visible = false
		player.set_process_input(false)
		set_process(false)
		set_process_input(false)
		var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
		var endPopUp = ENDING_INDICATOR.instantiate()
		canvas_layer.add_child(endPopUp)
		endPopUp.position = center
		endPopUp.scale = Vector2(0, 0)
		create_tween().tween_property(endPopUp, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		await endPopUp.infected_indicator()
		var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
		canvas_layer.add_child(loadScreen)
		loadScreen.position = center
		loadScreen.scale = Vector2(0, 0)
		loadScreen.fowl_os_loading.texture_progress = loadScreen.CONNECTIONS_PROGRESS
		loadScreen.fowl_os_loading.texture_under = loadScreen.CONNECTIONS_UNDER
		endPopUp.queue_free()
		create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		loadScreen.text_change()
		await loadScreen.fill_up()
		get_tree().change_scene_to_packed(FOWL_OPERATING_SYSTEM)
	elif lives <= 0:
		Music.tenser.stop()
		Sfx.detected.play()
		cmdLine.com_line.text = ""
		cmdLine.com_line_text_display("FOUND YOU.", 0.1)
		for i in antiviruses.get_children():
			i.queue_free()
		change_command_timer.stop()
		enemy_spawn.stop()
		mouse_particles.visible = false
		set_process(false)
		set_process_input(false)
		var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
		var endPopUp = ENDING_INDICATOR.instantiate()
		canvas_layer.add_child(endPopUp)
		endPopUp.position = center
		endPopUp.scale = Vector2(0, 0)
		create_tween().tween_property(endPopUp, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		await endPopUp.detected_indicator()
		var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
		canvas_layer.add_child(loadScreen)
		loadScreen.position = center
		loadScreen.scale = Vector2(0, 0)
		loadScreen.fowl_os_loading.texture_progress = loadScreen.CONNECTIONS_PROGRESS
		loadScreen.fowl_os_loading.texture_under = loadScreen.CONNECTIONS_UNDER
		endPopUp.queue_free()
		cmdLine.exit()
		create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
		loadScreen.reboot()
		await loadScreen.fill_up()
		get_tree().change_scene_to_packed(FOWL_CONNECTIONS)

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

func _on_change_command_timer_timeout() -> void:
	player.set_process_input(false)
	cmdLine.com_line.text = ""
	GlobalVars.current_activity = ActivityOptions.pick_random()
	GlobalVars.current_direction = DirectionOptions.pick_random()
	if not change_command_timer.wait_time < 5:
		change_command_timer.wait_time -= (0.3 + adder)
		adder += 0.2
	change_command_timer.start()
	await cmdLine.com_line_text_display(str(GlobalVars.current_activity) + " " + str(GlobalVars.current_direction), 0.05)
	player.set_process_input(true)
	
func hurt():
	hurt_flash.modulate.a = 1
	Sfx.hurt.play()
	lives -= 1
	create_tween().tween_property(hurt_flash, "modulate:a", 0, 0.5).set_ease(Tween.EASE_IN_OUT)

func _on_enemy_spawn_timeout() -> void:
	if not enemy_spawn.wait_time < 2:
		enemy_spawn.wait_time -= (0.2 + enemy_time_adder)
		enemy_time_adder += 0.05
	path_follow_2d.progress = RandomNumberGenerator.new().randi_range(0, 1940)
	var antivirus = ANTIVIRUS.instantiate()
	antivirus.global_position = marker_2d.global_position
	antiviruses.add_child(antivirus)
	enemy_spawn.start()
