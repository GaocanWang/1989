extends TileMapLayer

var frames = [
	Vector2i(5, 0),
	Vector2i(6, 0),
	Vector2i(7, 0),
	Vector2i(8, 0)
]
var paused : bool = false
var crumble_history : Array = []
var x : int

func _ready() -> void:
	var used_rect = get_used_rect()
	x = used_rect.end.x - 1
	while x > used_rect.position.x - 1:
		while paused:
			await get_tree().process_frame
		var column_cells: Array = []
		for y in range(used_rect.position.y, used_rect.end.y):
			var cell = Vector2i(x, y)
			if get_cell_source_id(cell) != -1:
				column_cells.append(cell)
				crumble_tile(cell)
		crumble_history.append(column_cells)
		await get_tree().create_timer(2.0).timeout
		x -= 1

func _process(_delta: float) -> void:
	var atlas_coords = get_cell_atlas_coords(local_to_map(PlayerManager.player.global_position + Vector2(-2,0)))
	if atlas_coords == Vector2i(8, 0) && !paused:
		paused = true
		get_tree().paused = true
		await SceneTransition.fade_out()
		var last_column = crumble_history.pop_back()
		var second_last_column = crumble_history.pop_back()
		for cell in last_column:
			set_cell(cell, 3, Vector2i(8, 5))
		for cell in second_last_column:
			set_cell(cell, 3, Vector2i(8, 5))
		x += 2
		await get_tree().create_timer(0.5).timeout
		PlayerManager.player.state_machine.change_state( PlayerManager.player.state_machine.states[0] )
		await SceneTransition.fade_in()
		paused = false
		get_tree().paused = false
		PlayerManager.player.check_pressed()

func crumble_tile(cell: Vector2i):
	for frame in frames:
		if paused:
			break
		else:
			set_cell(cell, 3, frame)
			await get_tree().create_timer(0.5).timeout
