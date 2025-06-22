extends PointLight2D



func _ready() -> void:
	flicker()



func flicker() -> void:
	energy = randf() * 0.01 + 0.5
	scale = Vector2( 2, 2 ) * energy
	if self.visible == true && !is_inside_tree():
		await get_tree().create_timer( 0.1 ).timeout
		flicker()
	pass
