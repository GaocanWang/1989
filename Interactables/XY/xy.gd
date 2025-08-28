class_name XY extends Area2D

var dialog_items : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_3 : Array[ DialogItem ]

@onready var animation_player: AnimationPlayer = $CanvasLayer/Sprite2D/AnimationPlayer
@onready var sprite_2d: Sprite2D = $CanvasLayer/Sprite2D


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
	
	sprite_2d.hide()
	
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
	get_tree().paused = true
	sprite_2d.show()
	animation_player.play("lower_art")
	await animation_player.animation_finished
	DialogSystem.show_dialog( dialog_items_2 )
	await DialogSystem.finished
	get_tree().paused = true
	animation_player.play("dissolve")
	await animation_player.animation_finished
	DialogSystem.show_dialog( dialog_items_3 )
	await DialogSystem.finished
	LevelManager.load_new_level( "res://Levels/Part2/02.tscn", "WChangeroomTransition", Vector2.ZERO )
	pass
