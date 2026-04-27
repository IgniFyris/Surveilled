extends Node2D

const MOUSE_CLICK_PARTICLES = preload("uid://d3kcljcgixdmc")
const FOWL_OS_POP_UP = preload("uid://chkats5ngarti")
const PROGRAM_LOAD_SCREEN = preload("uid://bbyvgnoa7o663")
const FOWL_DOWNLOADS = preload("uid://ceoqbli1r6u2d")
const FOWL_CONNECTIONS = preload("uid://33u010ucbdw")

const DOWNLOADS_INFECTED = preload("uid://3mh6nbu7wu7h")
const CONNECTIONS_INFECTED = preload("uid://bgvnua4jsnf8m")

@onready var mouse_particles: CPUParticles2D = $MouseParticles
@onready var fowl_main_program: TextureButton = $FowlMainProgram
@onready var fowl_downloads: TextureButton = $FowlDownloads
@onready var fowl_download_complete: ColorRect = $FowlDownloadComplete
@onready var fowl_connections: TextureButton = $FowlConnections
@onready var fowl_connections_complete: ColorRect = $FowlConnectionsComplete

@onready var pw_1: RichTextLabel = $PW1
@onready var pw_2: RichTextLabel = $PW2

var pressed = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if GlobalVars.DownloadsCompleted == true:
		fowl_downloads.disabled = true
		fowl_downloads.texture_normal = DOWNLOADS_INFECTED
		fowl_download_complete.mouse_filter = Control.MOUSE_FILTER_STOP
	if GlobalVars.ConnectionsCompleted == true:
		fowl_connections.disabled = true
		fowl_connections.texture_normal = CONNECTIONS_INFECTED
		fowl_connections_complete.mouse_filter = Control.MOUSE_FILTER_STOP
	
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
	disable_programs()
	var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	var osPopUp = FOWL_OS_POP_UP.instantiate()
	add_child(osPopUp)
	osPopUp.position = center
	osPopUp.scale = Vector2(0, 0)
	create_tween().tween_property(osPopUp, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
	await osPopUp.tree_exited
	enable_programs()

func _on_fowl_downloads_pressed() -> void:
	disable_programs()
	var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
	add_child(loadScreen)
	loadScreen.position = center
	loadScreen.scale = Vector2(0, 0)
	loadScreen.fowl_os_loading.texture_progress = loadScreen.DOWNLOADS_PROGRESS
	loadScreen.fowl_os_loading.texture_under = loadScreen.DOWNLOADS_UNDER
	loadScreen.text_change()
	create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
	await loadScreen.fill_up()
	get_tree().change_scene_to_packed(FOWL_DOWNLOADS)

func disable_programs():
	fowl_main_program.disabled = true
	fowl_connections.disabled = true
	fowl_downloads.disabled = true

func enable_programs():
	fowl_main_program.disabled = false
	fowl_connections.disabled = false
	fowl_downloads.disabled = false

func _on_fowl_download_complete_mouse_entered() -> void:
	pw_1.visible = true

func _on_fowl_download_complete_mouse_exited() -> void:
	pw_1.visible = false


func _on_fowl_connections_pressed() -> void:
	disable_programs()
	var center = Vector2(get_viewport_rect().size.x/2, get_viewport_rect().size.y/2)
	var loadScreen = PROGRAM_LOAD_SCREEN.instantiate()
	add_child(loadScreen)
	loadScreen.position = center
	loadScreen.scale = Vector2(0, 0)
	loadScreen.fowl_os_loading.texture_progress = loadScreen.CONNECTIONS_PROGRESS
	loadScreen.fowl_os_loading.texture_under = loadScreen.CONNECTIONS_UNDER
	loadScreen.text_change()
	create_tween().tween_property(loadScreen, "scale", Vector2(1.0, 1.0), 0.3).set_ease(Tween.EASE_IN_OUT)
	await loadScreen.fill_up()
	get_tree().change_scene_to_packed(FOWL_CONNECTIONS)

func _on_fowl_connections_complete_mouse_entered() -> void:
	pw_2.visible = true

func _on_fowl_connections_complete_mouse_exited() -> void:
	pw_2.visible = false
