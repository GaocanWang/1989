@tool
class_name StorageTransition extends Area2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_file( "*.tscn" ) var level
@export var target_transition_area : String = "LevelTransition"

@export var door : bool = false

@export_category("Collision Area Settings")

@export_range(1,12,1, "or_greater") var size : int = 2 :
	set( _v ):
		size = _v
		_update_area()

@export var side: SIDE = SIDE.LEFT :
	set( _v ):
		side = _v
		_update_area()

@export var snap_to_grid : bool = false :
	set( _v ):
		_snap_to_grid()

@onready var collision_shape: CollisionShape2D = $CollisionShape2D

var dialog_items : Array[ DialogItem ]


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	
	monitoring = false
	_place_player()
	
	await LevelManager.level_loaded
	
	monitoring = true
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	body_entered.connect( _player_entered )
	
	LevelManager.part3.connect( _on_part_3 )
	
	for c in get_children():
		dialog_items.append( c )
	
	pass


func _player_entered( _p : Node2D ) -> void:
	if LevelManager.flags.storage_open:
		if get_parent().name == "02":
			DialogSystem.show_dialog( dialog_items )
		else:
			LevelManager.load_new_level( level, target_transition_area, get_offset() )
	pass


func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 12
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 12
		if side == SIDE.TOP:
			offset.y *= -1
	
	return offset


func _update_area() -> void:
	var new_rect : Vector2 = Vector2( 24, 24 )
	var new_position : Vector2 = Vector2.ZERO
	
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 12
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 12
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 12
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 12
	
	if collision_shape == null:
		collision_shape = get_node("CollisionShape2D")
	
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position


func _snap_to_grid() -> void:
	position.x = round( position.x / 12 ) * 12
	position.y = round( position.y / 12 ) * 12


func _on_area_enter( _a : Area2D ) -> void:
	LevelManager.near_storage = true
	pass


func _on_area_exit( _a : Area2D ) -> void:
	LevelManager.near_storage = false
	pass


func _on_part_3() -> void:
	if level == "uid://dfd4xxeb28efh":
		level = "res://Levels/Part2/17.tscn"
