class_name Drain extends Area2D

var first_time : bool = true
var dialog_items_1 : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_repeat : Array[ DialogItem ]


func _ready() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c.name == "1":
			for d in c.get_children():
				dialog_items_1.append( d )
		elif c.name == "2":
			for d in c.get_children():
				dialog_items_2.append( d )
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
	if ( LevelManager.puzzle_solved ):
		DialogSystem.show_dialog( dialog_items_2 )
	elif ( first_time ):
		first_time = false
		DialogSystem.show_dialog( dialog_items_1 )
	else:
		DialogSystem.show_dialog( dialog_items_repeat )
	pass
