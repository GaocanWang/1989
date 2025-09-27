extends TileMapLayer

var frames = [
	Vector2i(5, 0),
	Vector2i(6, 0),
	Vector2i(7, 0),
	Vector2i(8, 0)
]

func _ready() -> void:
	var used_rect = get_used_rect()
	for x in range(used_rect.end.x - 1, used_rect.position.x - 1, -1):
		for y in range(used_rect.position.y, used_rect.end.y):
			var cell = Vector2i(x, y)
			if get_cell_source_id(cell) != -1:
				crumble_tile(cell)
		await get_tree().create_timer(2.0).timeout

func _process(_delta: float) -> void:
	var atlas_coords = get_cell_atlas_coords(local_to_map(PlayerManager.player.global_position))
	if atlas_coords in frames:
		print("ded")

func crumble_tile(cell: Vector2i):
	for frame in frames:
		set_cell(cell, 3, frame)
		await get_tree().create_timer(0.5).timeout
