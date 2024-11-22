extends Node2D

const START_LEVEL : String = "res://Levels/Part1/01.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new: Button = $CanvasLayer/Control/ButtonNew
@onready var button_continue: Button = $CanvasLayer/Control/ButtonContinue
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

var dialog_items : Array[ DialogItem ]




func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	
	if SaveManager.get_save_file() == null:
		button_continue.disabled = true
		button_continue.visible = false
	
	$CanvasLayer/SplashScene.finished.connect( setup_title_screen )
	
	LevelManager.level_load_started.connect( exit_title_screen )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	
	pass



func setup_title_screen() -> void:
	AudioManager.play_music( music )
	button_new.pressed.connect( start_game )
	button_continue.pressed.connect( load_game )
	button_new.grab_focus()
	
	PauseMenu.process_mode = Node.PROCESS_MODE_DISABLED
	
	button_new.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_continue.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	
	pass



func start_game() -> void:
	$CanvasLayer/Control.process_mode = Node.PROCESS_MODE_DISABLED
	
	play_audio( button_press_audio )
	
	animation_player.play( "black_screen" )
	
	#play_audio( 80s ahh music )
	
	await get_tree().create_timer( 2.0 ).timeout
	
	DialogSystem.show_dialog( dialog_items )
	
	await DialogSystem.finished
	
	LevelManager.load_new_level( START_LEVEL, "LevelTransition", Vector2(0, -12) )
	
	pass


func load_game() -> void:
	play_audio( button_press_audio )
	SaveManager.load_game()
	pass



func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	self.queue_free()
	pass



func play_audio( _a : AudioStream ) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
