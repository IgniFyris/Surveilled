extends Node2D

signal hack_finished

@onready var comp_screen: RichTextLabel = $CompScreen
const TUTORIAL = preload("uid://tfrbmimnvxvf")

var text = "Requesting Authorization From : http://zanb.se/?23&88&far=2

Authorized...

0.9574166569700704 0.5004976975937906
0.4014738470208381 0.39719298497063815
0.0909692092333999 0.3058918621658303
Going Deeper....

0.64354739015636 0.42501047229042455
0.7868945382655759 0.22673864429495083
0.5174748624808985
Compression Complete.

Requesting Authorization...

Decryption Unsuccesful Attempting Retry...

Calculating Space Requirements

....Searching...

Waiting for response...

Calculating Space Requirements

0.7375615272193784 0.9586763757320821
0.4954214552326983 0.956265459160797
0.7641205172189167 0.8145544037345976
0.8105485452262626 0.519725615569094
0.05145199586660476 0.6947467519382113

Access Granted...

Hit 'ENTER' to proceed..."

func _input(event: InputEvent) -> void:
	if Input.is_action_pressed("TutStart"):
		get_tree().change_scene_to_packed(TUTORIAL)

func _ready() -> void:
	set_process_input(false)
	comp_text_display(text, comp_screen, 0.01)

func comp_text_display(comp_text : String, comp_text_container : RichTextLabel, speed : float):
	var text_array = comp_text.rsplit()
	
	for character in text_array:
		comp_text_container.text = comp_screen.text + character
		await get_tree().create_timer(speed).timeout
	
	hack_finished.emit()

func _on_hack_finished() -> void:
	set_process_input(true)
