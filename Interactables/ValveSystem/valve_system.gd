class_name ValveSystem extends CanvasLayer

var valve_1_rotation : int = 0
var valve_2_rotation : int = 0
var valve_3_rotation : int = 0
var valve_4_rotation : int = 0

var left_arrow_rotation : int = 120
var right_arrow_rotation : int = 180

var top_bar_position : int = 950
var bottom_bar_position : int = 800


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_up"):
		valve_1_rotation += 45
		left_arrow_rotation += 60
		top_bar_position += 150
		var tween = get_tree().create_tween()
		tween.tween_property($Valve1, "rotation_degrees", valve_1_rotation, 0.3)
		tween.parallel().tween_property($LeftArrow, "rotation_degrees", left_arrow_rotation, 0.3)
		tween.parallel().tween_property($TopBar, "position", Vector2( top_bar_position, 350 ), 0.3)
	elif event.is_action_pressed("ui_left"):
		valve_2_rotation += 45
		left_arrow_rotation -= 60
		top_bar_position += 150
		var tween = get_tree().create_tween()
		tween.tween_property($Valve2, "rotation_degrees", valve_2_rotation, 0.3)
		tween.parallel().tween_property($LeftArrow, "rotation_degrees", left_arrow_rotation, 0.3)
		tween.parallel().tween_property($TopBar, "position", Vector2( top_bar_position, 350 ), 0.3)
	elif event.is_action_pressed("ui_right"):
		valve_3_rotation += 45
		right_arrow_rotation += 60
		bottom_bar_position += 150
		var tween = get_tree().create_tween()
		tween.tween_property($Valve3, "rotation_degrees", valve_3_rotation, 0.3)
		tween.parallel().tween_property($RightArrow, "rotation_degrees", right_arrow_rotation, 0.3)
		tween.parallel().tween_property($BottomBar, "position", Vector2( bottom_bar_position, 430 ), 0.3)
	elif event.is_action_pressed("ui_down"):
		valve_4_rotation += 45
		left_arrow_rotation -= 60
		right_arrow_rotation -= 60
		var tween = get_tree().create_tween()
		tween.tween_property($Valve4, "rotation_degrees", valve_4_rotation, 0.3)
		tween.parallel().tween_property($LeftArrow, "rotation_degrees", left_arrow_rotation, 0.3)
		tween.parallel().tween_property($RightArrow, "rotation_degrees", right_arrow_rotation, 0.3)
