extends Node

const PLAYER = preload("res://Player/player.tscn")
const INVENTORY_DATA : InventoryData = preload("res://GUI/pause_menu/inventory/player_inventory.tres")

signal camera_shook( trauma : float )
signal interact_pressed
signal key_pressed

var interact_handled : bool = true
var player : Player
var player_spawned : bool = false

var past_positions = []
var size = 100


func _ready() -> void:
	past_positions.resize( size )
	
	LevelManager.level_load_started.connect( reset_positions )
	
	add_player_instance()
	await get_tree().create_timer(0.2).timeout
	player_spawned = true


func add_player_instance() -> void:
	player = PLAYER.instantiate()
	add_child( player )
	pass



func set_player_position( _new_pos : Vector2 ) -> void:
	player.global_position = _new_pos
	pass



func set_as_parent( _p : Node2D ) -> void:
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )



func unparent_player( _p : Node2D ) -> void:
	_p.remove_child( player )



func interact() -> void:
	interact_handled = false
	interact_pressed.emit()



func shake_camera( trauma : float = 1 ) -> void:
	camera_shook.emit( trauma )



func reset_positions() -> void:
	past_positions = []
	past_positions.resize( size )
