extends Node

signal level_load_started
signal level_loaded
signal TileMapBoundsChanged( bounds : Array[ Vector2 ] )
signal part2
signal changeroom_unlocked
signal part3
signal extra_dialogue

var current_tilemap_bounds : Array[ Vector2 ]
var target_transition : String
var position_offset : Vector2
var levels_explored : Array[ String ]

var locker_interacted : bool = false
var x_interacted : bool = false
var y_interacted : bool = false
var puzzle_solved : bool = false
var valve_unlocked : bool = false
var near_valve : bool = false
var changeroom_open : bool = false
var near_changeroom : bool = false
var part_3 : bool = true
var storage_open : bool = false
var near_storage : bool = false


func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()


func change_tilemap_bounds( bounds : Array[ Vector2 ] ) -> void:
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


func load_new_level(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	if ResourceUID.get_id_path(ResourceUID.text_to_id(level_path)) == "res://Levels/Part2/10.tscn" && !(x_interacted && y_interacted):
		level_path = "res://Levels/Part2/13.tscn"
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	await SceneTransition.fade_in()
	
	PlayerManager.player.check_pressed()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	if ( !levels_explored.has(level_path) && !get_tree().current_scene.dialog_items.is_empty() ):
		levels_explored.append(level_path)
		DialogSystem.show_dialog( get_tree().current_scene.dialog_items )
		await DialogSystem.finished
	else:
		var node = get_tree().current_scene.get_node(target_transition)
		if ( !node.dialog_items.is_empty() && node.name != "WChangeroomTransition" ):
			DialogSystem.show_dialog( node.dialog_items )
			await DialogSystem.finished
	
	pass


func load_new_part(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.instant_fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	if level_path == "res://Levels/Part2/01.tscn":
		part2.emit()
		print(level_path)
	
	await SceneTransition.long_fade_in()
	
	PlayerManager.player.check_pressed()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	if ( !levels_explored.has(level_path) && !get_tree().current_scene.dialog_items.is_empty() ):
		levels_explored.append(level_path)
		DialogSystem.show_dialog( get_tree().current_scene.dialog_items )
		await DialogSystem.finished
	
	pass
