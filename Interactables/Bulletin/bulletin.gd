class_name Bulletin extends Area2D

@onready var sprite: Sprite2D = $Sprite2D

var dialog_items : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var showing : bool = false



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
	
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if showing:
			showing = false
			sprite.hide()
			get_tree().paused = false
			DialogSystem.show_dialog( dialog_items_2 )


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
	sprite.show()
	showing = true
	pass
