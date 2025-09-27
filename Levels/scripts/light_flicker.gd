extends PointLight2D



func _ready() -> void:
	flicker()



func flicker() -> void:
	visible = !visible
	await get_tree().create_timer( randf() ).timeout
	flicker()
	pass
