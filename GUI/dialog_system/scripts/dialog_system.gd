@tool
@icon( "res://GUI/dialog_system/icons/star_bubble.svg" )
class_name DialogSystemNode extends CanvasLayer

signal finished
signal letter_added( letter : String )

signal debate_failed

var is_active : bool = false
var text_in_progress : bool = false
var waiting_for_choice : bool = false

var text_speed : float = 0.02
var text_length : int = 0
var plain_text : String

var dialog_items : Array[ DialogItem ]
var dialog_item_index : int = 0

var slow : bool = false
var debate : bool = false
var debate_fails : int = 0

@onready var dialog_ui: Control = $DialogUI
@onready var content: RichTextLabel = $DialogUI/PanelContainer/RichTextLabel
@onready var name_label: Label = $DialogUI/NameLabel
@onready var portrait_sprite: DialogPortrait = $DialogUI/PortraitSprite
@onready var dialog_progress_indicator: PanelContainer = $DialogUI/DialogProgressIndicator
@onready var dialog_progress_indicator_label: Label = $DialogUI/DialogProgressIndicator/Label
@onready var timer: Timer = $DialogUI/Timer
@onready var audio_stream_player: AudioStreamPlayer = $DialogUI/AudioStreamPlayer
@onready var choice_options : VBoxContainer = $DialogUI/VBoxContainer
@onready var content_container: PanelContainer = $DialogUI/PanelContainer
@onready var textbox_animation_player: AnimationPlayer = $DialogUI/AnimationPlayer
@onready var portrait_animation_player: AnimationPlayer = $DialogUI/AnimationPlayer2
@onready var background_animation_player: AnimationPlayer = $DialogUI/TextureRect/AnimationPlayer
@onready var background: TextureRect = $DialogUI/TextureRect
@onready var progress_bar: ProgressBar = $DialogUI/ProgressBar
@onready var timer_2: Timer = $DialogUI/Timer2
@onready var audio_player: AudioStreamPlayer2D = $DialogUI/AudioStreamPlayer2D




func _ready() -> void:
	if Engine.is_editor_hint():
		if get_viewport() is Window:
			get_parent().remove_child( self )
			return
		return
	timer.timeout.connect( _on_timer_timeout )
	timer_2.timeout.connect( _on_timer_2_timeout )
	timer_2.wait_time = 5.0
	dialog_ui.visible = false
	pass



func _process(delta: float) -> void:
	if ( debate ):
		progress_bar.value = timer_2.time_left
	pass



## Handle key presses, but only if Dialog System is active
func _unhandled_input( _event: InputEvent ) -> void:
	if is_active == false:
		return
	if(
			_event.is_action_pressed("interact") or 
			_event.is_action_pressed("ui_accept")
	):
		if text_in_progress == true:
			content.visible_characters = text_length
			timer.stop()
			if ( dialog_item_index < dialog_items.size() - 1 ):
				if ( dialog_items[ dialog_item_index ] is DebateText && dialog_items[ dialog_item_index + 1 ] is DebateChoice ):
					dialog_item_index += 1
					start_dialog()
					return
			text_in_progress = false
			show_dialog_button_indicator( true )
			return
		elif waiting_for_choice == true:
			return
		
		dialog_item_index += 1
		if dialog_item_index < dialog_items.size():
			start_dialog()
		else:
			hide_dialog()
	pass



## Show the dialog UI
func show_dialog( _items : Array[ DialogItem ] ) -> void:
	is_active = true
	dialog_ui.process_mode = Node.PROCESS_MODE_ALWAYS
	dialog_items = _items
	dialog_item_index = 0
	get_tree().paused = true
	PlayerManager.player.state_machine.change_state( PlayerManager.player.state_machine.states[0] )
	await get_tree().process_frame
	start_dialog()
	dialog_ui.visible = true
	textbox_animation_player.play("textbox_rise")
	if (portrait_sprite.texture == null ):
		portrait_animation_player.play("portrait_appear_left")
	else:
		portrait_animation_player.play("portrait_appear_right")
	pass



## Hide Dialog System UI
func hide_dialog() -> void:
	textbox_animation_player.play("textbox_drop")
	if (portrait_sprite.texture == null):
		portrait_animation_player.play("portrait_disappear_left")
	elif (portrait_sprite.texture.resource_path == "res://npc/sprites/portraits/trial spritesheet.png"):
		portrait_animation_player.play("portrait_disappear_left")
	else:
		portrait_animation_player.play("portrait_disappear_right")
	await portrait_animation_player.animation_finished
	is_active = false
	choice_options.visible = false
	dialog_ui.visible = false
	dialog_ui.process_mode = Node.PROCESS_MODE_DISABLED
	
	content.text = ""
	background.texture = null
	background.hide()
	progress_bar.hide()
	
	PlayerManager.player.check_pressed()
	get_tree().paused = false
	finished.emit()
	pass



## Initialize UI variables for a new Dialog Interaction
func start_dialog() -> void:
	waiting_for_choice = false
	show_dialog_button_indicator( false )
	var _d : DialogItem = dialog_items[ dialog_item_index ]
	
	if _d is DialogText:
		set_dialog_text( _d as DialogText )
	elif _d is DialogChoice:
		set_dialog_choice( _d as DialogChoice )
	elif _d is DebateText:
		set_dialog_text( _d as DebateText )
	elif _d is DebateChoice:
		set_dialog_choice( _d as DebateChoice )
	elif _d is DialogBackground:
		set_dialog_background( _d as DialogBackground )
	elif _d is DialogSFX:
		set_dialog_sfx( _d as DialogSFX )
	
	pass



## Set dialog and NPC variables, etc based on dialog item parameters.
## Once set, start text typing timer
func set_dialog_text( _d ) -> void:
	if ( _d is DebateText ):
		background.texture = _d.npc_info.background
		background.show()
		progress_bar.show()
	
	slow = _d.slow
	content.text = _d.text
	choice_options.visible = false
	name_label.text = _d.npc_info.npc_name
	portrait_sprite.audio_pitch_base = _d.npc_info.dialog_audio_pitch
	content.visible_characters = 0
	text_length = content.get_total_character_count()
	plain_text = content.get_parsed_text()
	text_in_progress = true
	start_timer()
	if portrait_sprite.texture != _d.npc_info.portrait:
		if (portrait_sprite.texture == null):
			pass
		else:
			portrait_animation_player.play("portrait_disappear_right")
			await portrait_animation_player.animation_finished
		portrait_sprite.texture = _d.npc_info.portrait
		if (portrait_sprite.texture == null ):
			pass
		else:
			portrait_animation_player.play("portrait_appear_right")
	portrait_sprite.frame = _d.frame
	pass



## Set dialog choice UI based on parameters
func set_dialog_choice( _d ) -> void:
	if ( _d is DebateChoice ):
		timer_2.start()
		debate = true
	
	choice_options.visible = true
	waiting_for_choice = true
	for c in choice_options.get_children():
		c.queue_free()
	
	for i in _d.dialog_branches.size():
		var _new_choice : Button = Button.new()
		_new_choice.text = _d.dialog_branches[ i ].text
		_new_choice.alignment = HORIZONTAL_ALIGNMENT_LEFT
		_new_choice.pressed.connect( _dialog_choice_selected.bind( _d.dialog_branches[ i ] ) )
		choice_options.add_child( _new_choice )
	
	if Engine.is_editor_hint():
		return
	await get_tree().process_frame
	await get_tree().process_frame
	choice_options.get_child( 0 ).grab_focus()
	pass



func _dialog_choice_selected( _d ) -> void:
	choice_options.visible = false
	
	if ( debate ):
		debate = false
		timer_2.stop()
		if ( !_d.correct ):
			debate_fails += 1
	
	if ( dialog_item_index < dialog_items.size() - 1):
		var temp_items = dialog_items
		var temp_index = dialog_item_index
		show_dialog( _d.dialog_items )
		await DialogSystem.finished
		dialog_items = temp_items
		show_dialog(dialog_items)
		dialog_item_index = temp_index + 1
	else:
		show_dialog( _d.dialog_items )
	
	check_debate_failed()
	
	pass



func set_dialog_background( _d : DialogBackground ):
	if ( background.texture == null ):
		background.texture = _d.background
		background_animation_player.play( "initial_fade_in" )
	elif ( _d.background != null ):
		background_animation_player.play( "fade_out" )
		await background_animation_player.animation_finished
		background.texture = _d.background
		background_animation_player.play( "fade_in" )
	else:
		background_animation_player.play( "final_fade_out" )
		await background_animation_player.animation_finished
		background.texture = null
	
	dialog_item_index += 1
	start_dialog()
	
	pass



func set_dialog_sfx( _d : DialogSFX ):
	if ( _d.sfx != null ):
		AudioManager.play_music( _d.sfx )
	else:
		AudioManager.play_music( get_tree().current_scene.music )
	dialog_item_index += 1
	start_dialog()
	pass



func _on_timer_timeout() -> void:
	content.visible_characters += 1
	if content.visible_characters <= text_length:
		letter_added.emit( plain_text[ content.visible_characters - 1 ] )
		start_timer()
	else:
		if ( dialog_item_index < dialog_items.size() - 1 ):
			if ( dialog_items[ dialog_item_index ] is DebateText && dialog_items[ dialog_item_index + 1 ] is DebateChoice ):
				dialog_item_index += 1
				start_dialog()
				return
		show_dialog_button_indicator( true )
		text_in_progress = false
	pass



func _on_timer_2_timeout() -> void:
	timer_2.stop()
	
	var temp_dialog : Array[ DialogItem ]
	temp_dialog.append( DebateText.new() )
	temp_dialog[0].text = "(I wasn’t fast enough…!)"
	temp_dialog[0].npc_info = load( "res://npc/00_npcs/amelia_np.tres" )
	
	if ( dialog_item_index < dialog_items.size() - 1):
		var temp_items = dialog_items
		var temp_index = dialog_item_index
		show_dialog( temp_dialog )
		await DialogSystem.finished
		dialog_items = temp_items
		show_dialog(dialog_items)
		dialog_item_index = temp_index + 1
	else:
		show_dialog( temp_dialog )
	
	debate_fails += 1
	check_debate_failed()
	
	pass



## Show dialog NEXT/END indicator once dialog item is complete and ready to advance
func show_dialog_button_indicator( _is_visible : bool ) -> void:
	dialog_progress_indicator.visible = _is_visible
	if dialog_item_index + 1 < dialog_items.size():
		dialog_progress_indicator_label.text = "NEXT"
	else:
		dialog_progress_indicator_label.text = "END"



func start_timer() -> void:
	timer.wait_time = text_speed
	# Manipulate wait_time
	var _char = plain_text[ content.visible_characters - 1 ]
	if ".,!?:;".contains( _char ):
		timer.wait_time *= 4
	elif ", ".contains( _char ):
		timer.wait_time *= 2
	
	if slow:
		timer.wait_time *= 4
	
	timer.start()
	pass



func check_debate_failed() -> void:
	if (debate_fails >= 2):
		debate = false
		debate_fails = 0
		debate_failed.emit()
		pass
