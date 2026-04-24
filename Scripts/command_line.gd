extends Node2D

@onready var com_line: RichTextLabel = $ComLineText
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func com_line_text_display(comp_text : String, speed : float):
	var text_array = comp_text.rsplit()
	
	for character in text_array:
		com_line.text = com_line.text + character
		await get_tree().create_timer(speed).timeout

func enter():
	animation_player.play("Enter")
	
func exit():
	animation_player.play_backwards("Enter")
	com_line.text = ""
	await animation_player.animation_finished
	queue_free()
