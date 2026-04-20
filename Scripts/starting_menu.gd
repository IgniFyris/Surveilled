extends Node2D

@onready var comp_screen: RichTextLabel = $CompScreen

func _ready() -> void:
	comp_text_display("testing to my ass
im gonna kill everyone
what is ths line brah
", comp_screen, 0.02)
	
func comp_text_display(comp_text : String, comp_text_container : RichTextLabel, speed : float):
	var text_array = comp_text.rsplit()
	
	for character in text_array:
		comp_text_container.text = comp_screen.text + character
		await get_tree().create_timer(speed).timeout
