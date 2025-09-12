class_name Locker extends Node2D

@onready var area: Area2D = $Area2D
@onready var sprite: Sprite2D = $Sprite2D

var dialog_items : Array[ DialogItem ]

@export var texture : Texture2D


func _ready() -> void:
	if LevelManager.lockers.has( str( get_path() ) ):
		sprite.texture = texture
	
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
	if LevelManager.lockers.has( str( get_path() ) ):
		PauseMenu.play_audio( load( "res://Interactables/Locker/locker open and close SFX.mp3" ) )
		sprite.texture = load("res://Interactables/Locker/closed.png")
		LevelManager.lockers.erase( str( get_path() ) )
	else:
		sprite.texture = texture
		if name == "Locker5-Y":
			DialogSystem.show_dialog( dialog_items )
		elif name == "Locker14-Tote":
			PauseMenu.play_audio( load( "res://Interactables/Locker/locker open and close SFX.mp3" ) )
			if !dialog_items.is_empty():
				get_tree().paused = true
				await PauseMenu.audio_stream_player.finished
				DialogSystem.show_dialog( dialog_items )
			LevelManager.lockers.append( str( get_path() ) )
		elif name == "Locker3-Dead":
			PauseMenu.play_audio( load( "res://Interactables/Locker/locker open and close SFX.mp3" ) )
			get_tree().paused = true
			await PauseMenu.audio_stream_player.finished
			if get_tree().current_scene.name == "17":
				play_locker_audio()
				DialogSystem.show_dialog( dialog_items )
				LevelManager.lockers.append( str( get_path() ) )
				await DialogSystem.finished
				PauseMenu.audio_stream_player.stop()
				LevelManager.load_new_level("res://Levels/Part2/18.tscn", "", Vector2.ZERO)
			else:
				DialogSystem.show_dialog( dialog_items )
				LevelManager.lockers.append( str( get_path() ) )
		else:
			PauseMenu.play_audio( load( "res://Interactables/Locker/locker open and close SFX.mp3" ) )
			if !LevelManager.flags.part_3 && !LevelManager.flags.locker_interacted:
				get_tree().paused = true
				await PauseMenu.audio_stream_player.finished
				DialogSystem.show_dialog( dialog_items )
				LevelManager.flags.locker_interacted = true
			LevelManager.lockers.append( str( get_path() ) )
	pass


func play_locker_audio() -> void:
	AudioManager.play_music(null)
	PauseMenu.play_audio( load( "res://Levels/music/locker.mp3" ) )
	await PauseMenu.audio_stream_player.finished
	PauseMenu.play_audio( load( "res://Levels/music/locker loop.mp3" ) )
	PauseMenu.audio_stream_player.stream.loop = true  #chopped why
