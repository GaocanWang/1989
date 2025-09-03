class_name SinkPieces extends Area2D

@onready var buttons: VBoxContainer = $CanvasLayer/VBoxContainer
@onready var yes: Button = $CanvasLayer/VBoxContainer/Button
@onready var no: Button = $CanvasLayer/VBoxContainer/Button2

var dialog_items_1 : Array[ DialogItem ]
var dialog_items_yes : Array[ DialogItem ]
var dialog_items_no : Array[ DialogItem ]
var dialog_items_repeat : Array[ DialogItem ]


func _ready() -> void:
	buttons.hide()
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	yes.pressed.connect( _on_yes )
	no.pressed.connect( _on_no )
	
	for c in get_children():
		if c.name == "1":
			for d in c.get_children():
				dialog_items_1.append( d )
		elif c.name == "Yes":
			for d in c.get_children():
				dialog_items_yes.append( d )
		elif c.name == "No":
			for d in c.get_children():
				dialog_items_no.append( d )
		elif c.name == "Repeat":
			for d in c.get_children():
				dialog_items_repeat.append( d )
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _on_yes() -> void:
	await get_tree().process_frame	
	buttons.hide()
	PlayerManager.INVENTORY_DATA.add_item( load( "res://Items/sink_piece.tres" ) )
	DialogSystem.show_dialog( dialog_items_yes )
	pass


func _on_no() -> void:
	await get_tree().process_frame
	buttons.hide()	
	DialogSystem.show_dialog( dialog_items_no )
	pass


func player_interact() -> void:
	await get_tree().process_frame
	if get_tree().current_scene.name == "19" && !PlayerManager.has_item( "Bloody Sink Piece" ):
		DialogSystem.show_dialog( dialog_items_1 )
		PlayerManager.INVENTORY_DATA.add_item( load( "res://Items/sink_piece.tres" ) )
	elif !PlayerManager.has_item( "Bloody Sink Piece" ):
		DialogSystem.show_dialog( dialog_items_1 )
		await DialogSystem.finished
		get_tree().paused = true
		buttons.show()
		yes.grab_focus()
	else:
		DialogSystem.show_dialog( dialog_items_repeat )
	pass
