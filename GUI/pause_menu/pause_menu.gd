extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var item_name: Label = $Control/Inventory/Description/VBoxContainer/ItemName
@onready var item_description: Label = $Control/Inventory/Description/VBoxContainer/ItemDescription
@onready var item_image: TextureRect = $Control/Inventory/Image/ItemImage

var is_paused : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	#button_save.pressed.connect( _on_save_pressed )
	#button_load.pressed.connect( _on_load_pressed )
	
	for button in $Control/PauseMenu.get_children():
		button.connect("focus_entered", Callable(self, "_on_button_focus").bind(button))
	
	pass # Replace with function body.


func _on_button_focus(button: Button):
	match button.text.to_lower():
		"continue":
			$Control/Inventory.hide()
			$Control/Settings.hide()
			$Control/Quit.hide()
		"inventory":
			$Control/Inventory.show()
			$Control/Settings.hide()
			$Control/Quit.hide()
		"settings":
			$Control/Settings.show()
			$Control/Inventory.hide()
			$Control/Quit.hide()
		"quit":
			$Control/Quit.show()
			$Control/Inventory.hide()
			$Control/Settings.hide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if is_paused == false:
			if DialogSystem.is_active:
				return
			show_pause_menu()
		else:
			hide_pause_menu()
		get_viewport().set_input_as_handled()


func show_pause_menu() -> void:
	get_tree().paused = true
	visible = true
	is_paused = true
	shown.emit()
	await get_tree().process_frame
	$Control/PauseMenu/Continue.grab_focus()


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()


func _on_save_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.save_game()
	hide_pause_menu()
	pass


func _on_load_pressed() -> void:
	if is_paused == false:
		return
	SaveManager.load_game()
	await LevelManager.level_load_started
	hide_pause_menu()
	pass


func update_item_name( new_text : String ) -> void: 
	item_name.text = new_text


func update_item_description( new_text : String ) -> void: 
	item_description.text = new_text


func update_item_image( new_image : Texture2D ) -> void:
	item_image.texture = new_image


func play_audio( audio : AudioStream ) -> void:
	audio_stream_player.stream = audio
	audio_stream_player.play()


func tree() -> SceneTree:
	return get_tree()
