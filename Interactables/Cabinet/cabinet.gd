class_name Cabinet extends Area2D

var dialog_items : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_3 : Array[ DialogItem ]
var dialog_items_repeat : Array[ DialogItem ]

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
		elif c.name == "3":
			for d in c.get_children():
				dialog_items_3.append ( d )
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
	if (first_time):
		first_time = false
		DialogSystem.show_dialog( dialog_items )
		await DialogSystem.finished
		get_tree().paused = true
		PauseMenu.play_audio( load( "res://Interactables/Cabinet/drawer open SFX.mp3" ) )
		await get_tree().create_timer( 1.0 ).timeout
		DialogSystem.show_dialog( dialog_items_2 )
		await DialogSystem.finished
		DocumentViewer.show_document(["This handbook is intended for lifeguards in AECC and provides a brief overview of duties and general guidelines to follow.", 
										"General rules\nAlways work in shifts\nMake sure one partner is always on deck\nImmediately aid anyone who requests assistance", 
										"In the case a swimmer requests for equipment, open the storage room. Make sure to log down which equipment is taken and the quantity. ALWAYS make sure to write down who has requested which items and see that they are all returned at the end of the day.\nKeep the storage room locked whenever not in use.",
										"In the case of emergencies, act accordingly:\nIf someone is drowning, immediately go to aid them.\nIn the case of a leak, tell your shift partner and go to investigate. Lock the door to the room if there is a burst pipe or worse and call maintenance.\nIn case of injury, aid them out of the pool (if they are swimming) and stay with them. If the first aid kit does not treat their injuries, call paramedics."])
		await DocumentViewer.finished
		PlayerManager.INVENTORY_DATA.add_item( load( "res://Items/handbook.tres" ) )
		DialogSystem.show_dialog( dialog_items_3 )
	else:
		DialogSystem.show_dialog( dialog_items_repeat )
	pass
