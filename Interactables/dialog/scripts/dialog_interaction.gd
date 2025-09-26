@tool
@icon( "res://GUI/dialog_system/icons/chat_bubbles.svg" )
class_name DialogInteraction extends Area2D

signal player_interacted
signal finished

@export var enabled : bool = true
@export var size : Vector2 = Vector2( 24, 24 ) : set = _set_size

var dialog_items : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	if name == "Debate":
		DialogSystem.debate_failed.connect( _on_debate_fail )
		DialogSystem.finished.connect( _check_dialog )
	elif name == "Check":
		DialogSystem.finished.connect( _check_dialog )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
		elif c.name == "Repeat":
			for d in c.get_children():
				dialog_items_2.append( d )
	
	pass



func player_interact() -> void:
	player_interacted.emit()
	await get_tree().process_frame
	await get_tree().process_frame
	if ( !LevelManager.interacted.has( str( get_path() ) ) ):
		LevelManager.interacted.append( str( get_path() ) )
		DialogSystem.show_dialog( dialog_items )
	else:
		if ( !dialog_items_2.is_empty() ):
			DialogSystem.show_dialog( dialog_items_2 )
		else:
			DialogSystem.show_dialog( dialog_items )
	DialogSystem.finished.connect( _on_dialog_finished )
	pass



func _on_area_enter( _a : Area2D ) -> void:
	if enabled == false || dialog_items.size() == 0:
		return
	#animation_player.play("show")
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	#animation_player.play("hide")
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _on_dialog_finished() -> void:
	DialogSystem.finished.disconnect( _on_dialog_finished )
	finished.emit()


func _check_dialog() -> void:
	if DialogSystem.current_dialog_text == "“Come back to us when you’re finished, okay?”":
		LevelManager.load_new_level( "res://Levels/Part2/04.tscn", "", Vector2.ZERO )
	elif DialogSystem.current_dialog_text == "“Now let [i]us[/i] do our thing.”":
		LevelManager.load_new_level( "res://Levels/Part2/15.tscn", "", Vector2.ZERO )
	elif DialogSystem.current_dialog_text == "“Which means he couldn’t have gotten knocked unconscious.”":
		LevelManager.part3.emit()
		LevelManager.flags.part_3 = true
	elif DialogSystem.current_dialog_text == "(I need to get out.)":
		PlayerManager.shake_camera()
		LevelManager.load_new_level( "res://Levels/Part3/08.tscn", "", Vector2.ZERO )


func _on_debate_fail() -> void:
	var temp_dialog : Array[ DialogItem ]
	for c in find_child("DebateFail").get_children():
		temp_dialog.append( c )
	DialogSystem.show_dialog( temp_dialog + dialog_items )
	pass


func _get_configuration_warnings() -> PackedStringArray:
	if _check_for_dialog_items() == false:
		return [ "Requires at least one DialogItem node." ]
	else:
		return []


func _check_for_dialog_items() -> bool:
	for c in get_children():
		if c is DialogItem:
			return true
	return false


func _set_size( value : Vector2 ) -> void:
	size = value
	var shape = RectangleShape2D.new()
	shape.size = size
	$CollisionShape2D.set_shape( shape )
