class_name Mirror extends Area2D

@export var music : AudioStream
@export var music2 : AudioStream

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

var playing : bool = false



func _ready() -> void:
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	pass


func _on_area_enter( _a : Area2D ) -> void:
	print("guh")
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func player_interact() -> void:
	print("true")
	if !playing:
		video_player.play()
		AudioManager.play_music( music )
	else:
		video_player.stop()
		AudioManager.play_music( music2 )
	pass
