extends Node2D
@onready var fowl_os_loading: TextureProgressBar = $FowlOSLoading
@onready var screen_text: RichTextLabel = $ScreenText

const FOWLOS_PROGRESS_UNDER = preload("uid://do4m1mehujd8w")
const FOWLOS_PROGRESS = preload("uid://nq4ae8jnx0gg")
const CONNECTIONS_UNDER = preload("uid://bsivkvnwiuj8")
const CONNECTIONS_PROGRESS = preload("uid://te8rxx522glh")
const DOWNLOADS_UNDER = preload("uid://cq0k2f4f1qtqn")
const DOWNLOADS_PROGRESS = preload("uid://bpw0g0f54y35v")

func _ready() -> void:
	GlobalVars.num_of_infected_nodes = 0
	GlobalVars.num_of_nodes = 0
	if get_parent() is not CanvasLayer:
		get_parent().mouse_particles.visible = false
	else:
		get_parent().get_parent().get_parent().mouse_particles.visible = false
	get_parent().set_process_input(false)
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	fill_up()
	Sfx.reboot.play()
	
func text_change():
	screen_text.text = "LOADING"
	while fowl_os_loading.value != 100:
		if screen_text.text != "LOADING...":
			screen_text.text = screen_text.text + "."
		elif screen_text.text == "LOADING...":
			screen_text.text = "LOADING"
		elif fowl_os_loading.value == 100:
			break
		await get_tree().create_timer(0.4).timeout
		
func reboot():
	screen_text.text = "REBOOTING"
	while fowl_os_loading.value != 100:
		if screen_text.text != "REBOOTING...":
			screen_text.text = screen_text.text + "."
		elif screen_text.text == "REBOOTING...":
			screen_text.text = "REBOOTING"
		elif fowl_os_loading.value == 100:
			break
		await get_tree().create_timer(0.4).timeout
	
func fill_up():
	while fowl_os_loading.value != 100:
		fowl_os_loading.value += 1
		await get_tree().create_timer(0.03).timeout

	screen_text.text = "LOAD COMPLETE!"
	Sfx.reboot.stop()
	Sfx.load_done.play()
	await get_tree().create_timer(2.0).timeout
