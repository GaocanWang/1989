class_name Cabinet extends Area2D

var dialog_items : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_3 : Array[ DialogItem ]
var dialog_items_4 : Array[ DialogItem ]


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
		elif c.name == "4":
			for d in c.get_children():
				dialog_items_4.append ( d )
	
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact() -> void:
	DialogSystem.show_dialog( dialog_items )
	await DialogSystem.finished
	get_tree().paused = true
	await get_tree().create_timer( 1.0 ).timeout
	DialogSystem.show_dialog( dialog_items_2 )
	await DialogSystem.finished
	get_tree().paused = true
	await get_tree().create_timer( 1.0 ).timeout
	DialogSystem.show_dialog( dialog_items_3 )
	await DialogSystem.finished
	get_tree().paused = true
	await get_tree().create_timer( 1.0 ).timeout
	DialogSystem.show_dialog( dialog_items_4 )
	pass
