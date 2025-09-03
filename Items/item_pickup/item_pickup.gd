@tool
class_name ItemPickup extends Node2D

@export var item_data : ItemData : set = _set_item_data

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D


var dialog_items : Array[ DialogItem ]


func _ready() -> void:
	_update_texture()
	if Engine.is_editor_hint():
		return
	area_2d.area_entered.connect( _on_area_enter )
	area_2d.area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact() -> void:
	await get_tree().process_frame
	if item_data:
		if PlayerManager.INVENTORY_DATA.add_item( item_data ) == true:
			DialogSystem.show_dialog( dialog_items )
			await DialogSystem.finished
			item_picked_up()
	pass


func item_picked_up() -> void:
	audio_stream_player_2d.play()
	visible = false
	await audio_stream_player_2d.finished
	queue_free()
	pass


func _set_item_data( value : ItemData ) -> void:
	item_data = value
	_update_texture()
	pass


func _update_texture() -> void:
	if item_data and sprite_2d:
		sprite_2d.texture = item_data.texture
	pass
