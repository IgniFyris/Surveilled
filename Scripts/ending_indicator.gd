extends Node2D
@onready var detected: Sprite2D = $Detected
@onready var infected: Sprite2D = $Infected

func detected_indicator():
	detected.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	detected.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	detected.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	detected.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	detected.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	detected.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	detected.visible = true
	
func infected_indicator():
	infected.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	infected.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	infected.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	infected.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	infected.visible = true
	
	await get_tree().create_timer(0.5).timeout
	
	infected.visible = false
	
	await get_tree().create_timer(0.5).timeout
	
	infected.visible = true
