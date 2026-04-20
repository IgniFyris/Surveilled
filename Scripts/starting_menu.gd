extends Node2D

@onready var comp_screen: RichTextLabel = $CompScreen

func _ready() -> void:
	comp_text_display("testing to my ass
im gonna kill everyone
what is ths line brah
", comp_screen)
	
func comp_text_display(comp_text : String, comp_text_container : RichTextLabel):
	var text_array = comp_text.rsplit()
	
	for i in text_array:
		comp_text_container.text = comp_screen.text + i
		await get_tree().create_timer(0.02).timeout
