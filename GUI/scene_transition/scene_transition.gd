extends CanvasLayer

@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer
@onready var texture_rect: TextureRect = $Control/TextureRect

var showing : bool = false


func _ready() -> void:
	texture_rect.hide()


func _unhandled_input(event: InputEvent) -> void:
	if showing && event.is_action_pressed("ui_accept"):
		showing = false
		texture_rect.hide()
		PauseMenu.play_audio( load("res://Interactables/MapHolder/SFX paper.mp3") )
		get_tree().paused = false


func fade_out() -> bool:
	animation_player.play("fade_out")
	await animation_player.animation_finished
	return true


func fade_in() -> bool:
	animation_player.play("fade_in")
	await animation_player.animation_finished
	return true


func long_fade_in() -> bool:
	animation_player.play("long_fade_in")
	await animation_player.animation_finished
	return true


func instant_fade_out() -> bool:
	animation_player.play("instant_fade_out")
	await animation_player.animation_finished
	return true


func show_image( image : Texture2D ):
	get_tree().paused = true
	showing = true
	texture_rect.texture = image
	texture_rect.show()
