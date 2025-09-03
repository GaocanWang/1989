class_name ValveIsntructions extends Area2D

var dialog_items : Array[ DialogItem ]


func _ready() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
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
	DialogSystem.show_dialog( dialog_items )
	await DialogSystem.finished
	DocumentViewer.show_document(["In the case where water levels are too high or low, the equalizing system will be able to reroute water supply to the desired rooms. Each of the four rooms and their water supply can be equalized or rerouted from the equalizer through bypassing the three stages designed for confirmation.", 
									"The [arrow] keys correspond to the left, upper, right, and bottom water supplies respectively. Upon clicking the key for the corresponding room, its contents will empty into directly connected rooms.", "If a room has one level full, it will empty into only one connected room. The system prioritizes rooms with the lowest percentage full, and with the lowest maximum capacity.", 
									"If a room has two levels full, and there are 2 connected rooms, it will split to add one level to each. If there are 3 connected rooms, it will empty 2 into one room. The system prioritizes rooms with the lowest percentage full, and with the lowest maximum capacity.", 
									"If a room has three levels full, and there are 3 connected rooms, it will split to add 1 to each. If there are 2 connected rooms, it will empty 3 levels into one room. The system prioritizes rooms with the lowest percentage full, and with the lowest maximum capacity.\nPressing [R] will reset a level to its original state."])
	pass
