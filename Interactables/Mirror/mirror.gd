class_name Mirror extends Area2D

@export var music : AudioStream
@export var music2 : AudioStream

var playing : bool = false
var video_player : VideoStreamPlayer



func _ready() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	for c in get_children():
		if c is VideoStreamPlayer:
			video_player = c
	
	pass


func _unhandled_input(event):
	if event.is_action_pressed("ui_accept"):
		if playing == true:
			playing = false
			video_player.stop()
			AudioManager.play_music( music2 )
			get_tree().paused = false


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact() -> void:
	if !playing:
		get_tree().paused = true
		await get_tree().process_frame
		playing = true
		video_player.play()
		AudioManager.play_music( music )
	pass
