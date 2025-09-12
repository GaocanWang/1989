class_name Drain extends Area2D

@onready var buttons: VBoxContainer = $CanvasLayer/VBoxContainer
@onready var yes: Button = $CanvasLayer/VBoxContainer/Button
@onready var no: Button = $CanvasLayer/VBoxContainer/Button2

var first_time : bool = true
var dialog_items_1 : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_3 : Array[ DialogItem ]
var dialog_items_repeat : Array[ DialogItem ]


func _ready() -> void:
	buttons.hide()
	
	yes.pressed.connect( _on_yes )
	no.pressed.connect( _on_no )
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c.name == "1":
			for d in c.get_children():
				dialog_items_1.append( d )
		elif c.name == "2":
			for d in c.get_children():
				dialog_items_2.append( d )
		elif c.name == "3":
			for d in c.get_children():
				dialog_items_3.append( d )
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


func player_interact() -> void:
	await get_tree().process_frame
	if ( LevelManager.flags.puzzle_solved ):
		DialogSystem.show_dialog( dialog_items_2 )
		await DialogSystem.finished
		get_tree().paused = true
		buttons.show()
		yes.grab_focus()
	elif ( first_time ):
		first_time = false
		DialogSystem.show_dialog( dialog_items_1 )
	else:
		DialogSystem.show_dialog( dialog_items_repeat )
	pass


func _on_yes() -> void:
	buttons.hide()
	PlayerManager.INVENTORY_DATA.add_item( load( "res://Items/lifeguard_keys.tres" ) )
	DialogSystem.show_dialog( dialog_items_3 )
	await DialogSystem.finished
	queue_free()
	pass


func _on_no() -> void:
	buttons.hide()	
	get_tree().paused = false
	pass
