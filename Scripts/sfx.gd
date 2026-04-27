extends AudioStreamPlayer
@onready var hurt: AudioStreamPlayer = $Hurt
@onready var ticktock: AudioStreamPlayer = $Ticktock
@onready var binary: AudioStreamPlayer = $Binary
@onready var click: AudioStreamPlayer = $Click
@onready var boom: AudioStreamPlayer = $Boom
@onready var correct: AudioStreamPlayer = $Correct
@onready var buzz: AudioStreamPlayer = $Buzz
@onready var reboot: AudioStreamPlayer = $Reboot
@onready var load_done: AudioStreamPlayer = $LoadDone
@onready var glitch: AudioStreamPlayer = $Glitch
@onready var success: AudioStreamPlayer = $Success
@onready var detected: AudioStreamPlayer = $Detected
@onready var error: AudioStreamPlayer = $Error
@onready var blrrr: AudioStreamPlayer = $Blrrr

func _on_buzz_finished() -> void:
	buzz.play()

func _on_ticktock_finished() -> void:
	ticktock.play()

func _on_binary_finished() -> void:
	binary.play()

func _on_blrrr_finished() -> void:
	blrrr.play()
