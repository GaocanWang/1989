@tool
class_name PartTransition extends Node2D

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

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

@onready var area: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var buttons: VBoxContainer = $CanvasLayer/Control/VBoxContainer
@onready var yes: Button = $CanvasLayer/Control/VBoxContainer/Button
@onready var no: Button = $CanvasLayer/Control/VBoxContainer/Button2
@onready var art: Sprite2D = $CanvasLayer/Control/Sprite2D

var dialog_items_1 : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_3 : Array[ DialogItem ]
var dialog_items_4 : Array[ DialogItem ]

var first_interaction : bool = true


func _ready() -> void:
	_update_area()
	if Engine.is_editor_hint():
		return
	
	buttons.hide()
	art.hide()
	
	area.monitoring = false
	_place_player()
	
	await LevelManager.level_loaded
	
	area.monitoring = true
	
	area.area_entered.connect( _on_area_enter )
	area.area_exited.connect( _on_area_exit )
	
	yes.pressed.connect( _on_yes )
	no.pressed.connect( _on_no )
	
	for c in get_children():
		for d in c.get_children():
			if c.name == "1":
				dialog_items_1.append( d )
			elif c.name == "2":
				dialog_items_2.append( d )
			elif c.name == "3":
				dialog_items_3.append( d )
			elif c.name == "4":
				dialog_items_4.append( d )
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( _player_entered.bind( _a ) )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( _player_entered.bind( _a ) )
	pass


func _player_entered( _p : Node2D ) -> void:
	await get_tree().process_frame
	
	if ( first_interaction ):
		AudioManager.play_music(null)
		
		DialogSystem.show_dialog( dialog_items_1 )
	
		await DialogSystem.finished
		
		first_interaction = false
	else: 
		DialogSystem.show_dialog( dialog_items_2 )
		
		await DialogSystem.finished
		
		get_tree().paused = true
		
		buttons.show()
		
		yes.grab_focus()
	pass


func _place_player() -> void:
	if name != LevelManager.target_transition:
		return
	PlayerManager.set_player_position( area.global_position + LevelManager.position_offset )


func get_offset() -> Vector2:
	var offset : Vector2 = Vector2.ZERO
	var player_pos = PlayerManager.player.global_position
	
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - area.global_position.y
		offset.x = 12
		if side == SIDE.LEFT:
			offset.x *= -1
	else:
		offset.x = player_pos.x - area.global_position.x
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
		collision_shape = get_node("Area2D/CollisionShape2D")
	
	collision_shape.shape.size = new_rect
	collision_shape.position = new_position


func _snap_to_grid() -> void:
	area.position.x = round( area.position.x / 12 ) * 12
	area.position.y = round( area.position.y / 12 ) * 12


func _on_yes() -> void:
	area.process_mode = Node.PROCESS_MODE_DISABLED
	buttons.hide()
	await SceneTransition.fade_out()
	await get_tree().create_timer(1).timeout
	#play door opening sound
	DialogSystem.show_dialog( dialog_items_3 )
	await DialogSystem.finished
	art.show()
	SceneTransition.fade_in()
	for n in 168:
		await get_tree().create_timer(0.01).timeout
		art.position.y += 4;
	DialogSystem.show_dialog( dialog_items_4 )
	await DialogSystem.finished
	get_tree().paused = false
	LevelManager.part2.emit()
	LevelManager.load_new_part( "res://Levels/Part2/04.tscn", "LevelTransition", get_offset() )
	pass


func _on_no():
	buttons.hide()	
	get_tree().paused = false
	pass
