extends Node2D
@onready var sprites: Node2D = $Sprites

@onready var blue: Sprite2D = $Sprites/Blue
@onready var red: Sprite2D = $Sprites/Red
@onready var green: Sprite2D = $Sprites/Green
@onready var hover_area: ColorRect = $HoverArea

var color
var done = false
var hovering = false

func _ready() -> void:	
	var ColorOptions = ["BLUE", "RED", "GREEN"]
	color = ColorOptions[randi_range(0, 2)]
	
	match color:
		"BLUE":
			blue.visible = true
		"GREEN":
			green.visible = true
		"RED":
			red.visible = true
	
func _input(_event: InputEvent) -> void:
	input_function(color)

func input_function(clr : String):
	if hovering:
		if Input.is_action_just_pressed("Click") and GlobalVars.current_color == clr and GlobalVars.current_action == "UPLOAD":
			Sfx.correct.play()
			hover_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var tw = create_tween().tween_property(sprites, "scale", Vector2(0, 0), 0.05)
			get_parent().get_parent().correctActions += 1
			await tw.finished
			remove()
		elif Input.is_action_just_pressed("RightClick") and GlobalVars.current_color == clr and GlobalVars.current_action == "DELETE":
			Sfx.correct.play()
			hover_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var tw = create_tween().tween_property(sprites, "scale", Vector2(0, 0), 0.05)
			get_parent().get_parent().correctActions += 1
			await tw.finished 
			remove()
		elif Input.is_action_just_pressed("RightClick") and GlobalVars.current_color == clr and GlobalVars.current_action == "UPLOAD" or (
			Input.is_action_just_pressed("Click") and GlobalVars.current_color == clr and GlobalVars.current_action == "DELETE"):
			hover_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var tw = create_tween().tween_property(sprites, "scale", Vector2(0, 0), 0.05)
			get_parent().get_parent().hurt()
			get_parent().get_parent().lives -= 1
			await tw.finished
			remove()
		elif (Input.is_action_just_pressed("RightClick") or Input.is_action_just_pressed("Click")) and GlobalVars.current_action != clr:
			hover_area.mouse_filter = Control.MOUSE_FILTER_IGNORE
			var tw = create_tween().tween_property(sprites, "scale", Vector2(0, 0), 0.05)
			get_parent().get_parent().hurt()
			get_parent().get_parent().lives -= 1
			await tw.finished
			remove()
			
func remove():
	var index = 0
	for i in get_parent().get_parent().foldersObjArray:
		if self.position == i:
			get_parent().get_parent().foldersObjArray.remove_at(index)
			break
		index += 1
	queue_free()

func _on_hover_area_mouse_entered() -> void:
	hovering = true
	create_tween().tween_property(sprites, "scale", Vector2(1.1, 1.1), 0.1).set_ease(Tween.EASE_IN_OUT)

func _on_hover_area_mouse_exited() -> void:
	hovering = false
	create_tween().tween_property(sprites, "scale", Vector2(1.0, 1.0), 0.1).set_ease(Tween.EASE_IN_OUT)
