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
	await get_tree().process_frame
	if open:
		audio_player.play()
		sprite.texture = load("res://Interactables/Locker/closed.png")
		open = false
	else:
		if name == "Locker5-Y":
			DialogSystem.show_dialog( dialog_items )
		elif name == "Locker14-Tote":
			audio_player.play()
			sprite.texture = load("res://Interactables/Locker/towels.png")
			if !dialog_items.is_empty():
				get_tree().paused = true
				await audio_player.finished
				DialogSystem.show_dialog( dialog_items )
			open = true
		elif name == "Locker3-Dead":
			audio_player.play()
			sprite.texture = load("res://Interactables/Locker/bodywhy.png")
			get_tree().paused = true
			await audio_player.finished
			if get_tree().current_scene.name == "17":
				play_locker_audio()
				DialogSystem.show_dialog( dialog_items )
				open = true
				await DialogSystem.finished
				audio_player.stop()
				LevelManager.load_new_level("res://Levels/Part2/18.tscn", "", Vector2.ZERO)
			else:
				DialogSystem.show_dialog( dialog_items )
				open = true
		else:
			audio_player.play()
			sprite.texture = load("res://Interactables/Locker/empty.png")
			if !LevelManager.part_3 && !LevelManager.locker_interacted:
				get_tree().paused = true
				await audio_player.finished
				DialogSystem.show_dialog( dialog_items )
				LevelManager.locker_interacted = true
			open = true
	pass


func play_locker_audio() -> void:
	AudioManager.play_music(null)
	audio_player.stream = load("res://Levels/music/locker.mp3")
	audio_player.play()
	await audio_player.finished
	audio_player.stream = load("res://Levels/music/locker loop.mp3")
	audio_player.play()
	audio_player.stream.loop = true
