extends Node

signal level_load_started
signal level_loaded
signal TileMapBoundsChanged( bounds : Array[ Vector2 ] )
signal part2

var current_tilemap_bounds : Array[ Vector2 ]
var target_transition : String
var position_offset : Vector2
var beenToPool : bool = false


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
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	await SceneTransition.fade_in()
	
	PlayerManager.player.check_pressed()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	var res := ResourceLoader.load(level_path)
	if res.resource_path == "res://Levels/Part2/02.tscn" && beenToPool == false:
		beenToPool = true
		part2.emit()
	
	pass


func load_new_part(
		level_path : String,
		_target_transition : String,
		_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	if level_path == "res://Levels/Part2/01.tscn":
		part2.emit()
	
	await SceneTransition.long_fade_in()
	
	PlayerManager.player.check_pressed()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	if level_path == "res://Levels/Part2/01.tscn":
		part2.emit()
	
	pass
