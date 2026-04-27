extends Node2D
@onready var node: Area2D = $Node

func _process(delta: float) -> void:
	if Input.is_action_pressed("Down"):
			node.position.y += 1
	elif Input.is_action_pressed("Up"):
			node.position.y -= 1
	elif Input.is_action_pressed("Left"):
			node.position.x -= 1
	elif Input.is_action_pressed("Right"):
			node.position.x += 1
	
