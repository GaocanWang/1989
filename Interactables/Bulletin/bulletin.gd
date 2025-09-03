class_name Bulletin extends Area2D

var dialog_items : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_repeat : Array[ DialogItem ]
var showing : bool = false
var first_time : bool = true



func _ready() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c.name == "1":
			for d in c.get_children():
				dialog_items.append( d )
		elif c.name == "2":
			for d in c.get_children():
				dialog_items_2.append ( d )
		elif c.name == "Repeat":
			for d in c.get_children():
				dialog_items_repeat.append ( d )
	
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact() -> void:
	await get_tree().process_frame
	if first_time:
		first_time = false
		DialogSystem.show_dialog( dialog_items )
		await DialogSystem.finished
		DocumentViewer.show_document(["Kickboards (14)\nNoodles (20)\nTowel (8)", "11:00 AM\nJ. Ji\n1 Kickboard taken", "2:00 PM\nY. Gurt\n2 Noodles taken", "2:35 PM\nK. Fern\n1 Noodle taken"])
		await DocumentViewer.finished
		DialogSystem.show_dialog( dialog_items_2 )
		await DialogSystem.finished
		PlayerManager.INVENTORY_DATA.add_item( load( "res://Items/equipment_log.tres" ) )
	else:
		DialogSystem.show_dialog( dialog_items_repeat )
	pass
