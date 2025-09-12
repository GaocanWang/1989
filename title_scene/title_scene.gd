extends Node2D

const START_LEVEL : String = "res://Levels/Part1/01.tscn"

@export var music : AudioStream
@export var button_focus_audio : AudioStream
@export var button_press_audio : AudioStream

@onready var button_new: Button = $CanvasLayer/Control/ButtonNew
@onready var button_continue: Button = $CanvasLayer/Control/ButtonContinue
@onready var button_options: Button = $CanvasLayer/Control/ButtonOptions
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer
@onready var animation_player: AnimationPlayer = $CanvasLayer/AnimationPlayer

var dialog_items_1 : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]




func _ready() -> void:
	get_tree().paused = true
	PlayerManager.player.visible = false
	
	PauseMenu.is_title_scene_active = true
	
	$CanvasLayer/SplashScene.finished.connect( setup_title_screen )
	
	LevelManager.level_load_started.connect( exit_title_screen )
	
	for c in get_children():
		for d in c.get_children():
			if c.name == "1":
				dialog_items_1.append( d )
			elif c.name == "2":
				dialog_items_2.append( d )
	
	pass



func setup_title_screen() -> void:
	AudioManager.play_music( music )
	button_new.pressed.connect( start_game )
	button_continue.pressed.connect( load_game )
	button_options.pressed.connect( open_options )
	button_new.grab_focus()
	button_new.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	button_continue.focus_entered.connect( play_audio.bind( button_focus_audio ) )
	pass



func start_game() -> void:
	$CanvasLayer/Control.process_mode = Node.PROCESS_MODE_DISABLED
	
	play_audio( button_press_audio )
	
	animation_player.play( "fadeout" )
	
	AudioManager.play_music(null)
	
	await get_tree().create_timer( 2.0 ).timeout
	
	DialogSystem.show_dialog( dialog_items_1 )
	
	await DialogSystem.finished
	
	animation_player.play( "full_screen" )
	
	await animation_player.animation_finished
	
	DialogSystem.show_dialog( dialog_items_2 )
	
	await DialogSystem.finished
	
	animation_player.play( "full_screen_fadeout" )
	
	await animation_player.animation_finished
	
	LevelManager.load_new_part( START_LEVEL, "LevelTransition", Vector2(0, -12) )
	
	pass


func load_game() -> void:
	play_audio( button_press_audio )
	SaveMenu.show_save_menu( "load" )
	pass


func open_options() -> void:
	PauseMenu.side_bar.hide()
	PauseMenu.show()
	PauseMenu.is_paused = true
	PauseMenu.master_slider.grab_focus()
	await PauseMenu.hidden
	button_options.grab_focus()
	PauseMenu.side_bar.show()
	pass


func exit_title_screen() -> void:
	PlayerManager.player.visible = true
	PauseMenu.is_title_scene_active = false
	self.queue_free()
	pass



func play_audio( _a : AudioStream ) -> void:
	audio_stream_player.stream = _a
	audio_stream_player.play()
