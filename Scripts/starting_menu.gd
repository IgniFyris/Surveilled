extends Node2D

@onready var comp_screen: RichTextLabel = $CompScreen

var comp_text: String = "testing to my ass
im gonna kill everyone
what is ths line brah
"
var text_array = comp_text.rsplit()

func _ready() -> void:
	for i in text_array:
		comp_screen.text = comp_screen.text + i
		await get_tree().create_timer(0.02).timeout
