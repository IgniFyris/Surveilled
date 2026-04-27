extends Area2D

const NODE = preload("uid://ndxe7eglmwwi")

@onready var node: Sprite2D = $Node
@onready var infected_node: Sprite2D = $InfectedNode

@onready var down: RayCast2D = $Raycasts/Down
@onready var right: RayCast2D = $Raycasts/Right
@onready var up: RayCast2D = $Raycasts/Up
@onready var left: RayCast2D = $Raycasts/Left

var infected = false

func check_free_directions() -> Array:
	var free = []
	if not up.is_colliding(): free.append("up")
	if not down.is_colliding(): free.append("down")
	if not left.is_colliding(): free.append("left")
	if not right.is_colliding(): free.append("right")
	return free

func _on_body_entered(body: Node2D) -> void:
	if not self.infected and body is Player:
		Sfx.correct.play()
		GlobalVars.num_of_infected_nodes += 1
		self.infected = true
		node.visible = false
		infected_node.visible = true
