class_name Locker extends Node2D

signal locker_opened

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var dialog_items : Array[ DialogItem ]

var open : bool = false


func _ready() -> void:
	area.area_entered.connect( _on_area_enter )
	area.area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append(c)
	
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact() -> void:
	if open:
		audio_player.play()
		sprite.texture = load("res://Interactables/Locker/closed.png")
	else:
		audio_player.play()
		sprite.texture = load("res://Interactables/Locker/empty.png")
		
		if !LevelManager.locker_interacted:
			get_tree().paused = true
			await audio_player.finished
			DialogSystem.show_dialog( dialog_items )
			LevelManager.locker_interacted = true
	
	open = !open
	pass
