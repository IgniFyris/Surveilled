extends Node

@onready var tenser: AudioStreamPlayer = $Tenser
@onready var tense: AudioStreamPlayer = $Tense
@onready var finale: AudioStreamPlayer = $Finale
@onready var buzz: AudioStreamPlayer = $Buzz

func _on_tenser_finished() -> void:
	tenser.play()

func _on_tense_finished() -> void:
	tense.play()

func _on_finale_finished() -> void:
	finale.play()

func _on_buzz_finished() -> void:
	buzz.play()
