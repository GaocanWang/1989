extends CanvasLayer

signal shown
signal hidden

@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var item_name: Label = $Control/Inventory/Description/VBoxContainer/ItemName
@onready var item_description: Label = $Control/Inventory/Description/VBoxContainer/ItemDescription
@onready var item_image: TextureRect = $Control/Inventory/Image/ItemImage
@onready var side_bar: VBoxContainer = $Control/SideBar

@onready var quit_to_menu: Button = $Control/Quit/VBoxContainer/QuitToMenuButton
@onready var quit_to_desktop: Button = $Control/Quit/VBoxContainer/QuitToDesktopButton
@onready var continue_button: Button = $Control/SideBar/Continue

@onready var master_slider: HSlider = $Control/Settings/VBoxContainer/MasterSlider
@onready var music_slider: HSlider = $Control/Settings/VBoxContainer/MusicSlider
@onready var sfx_slider: HSlider = $Control/Settings/VBoxContainer/SFXSlider

var is_paused : bool = false
var is_title_scene_active : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide_pause_menu()
	
	var config = ConfigFile.new()
	var err = config.load("user://settings.cfg")
	if err == OK:
		master_slider.value = config.get_value("audio", "master", master_slider.value)
		music_slider.value = config.get_value("audio", "music", music_slider.value)
		sfx_slider.value = config.get_value("audio", "sfx", sfx_slider.value)
		
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(master_slider.value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(music_slider.value))
		AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(sfx_slider.value))
	else:
		master_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
		music_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Music")))
		sfx_slider.value = db_to_linear(AudioServer.get_bus_volume_db(AudioServer.get_bus_index("SFX")))
	
	continue_button.pressed.connect( hide_pause_menu )
	quit_to_menu.pressed.connect( _quit_to_menu )
	quit_to_desktop.pressed.connect( _quit_to_desktop )
	
	master_slider.value_changed.connect(_on_slider_value_changed.bind("Master"))
	music_slider.value_changed.connect(_on_slider_value_changed.bind("Music"))
	sfx_slider.value_changed.connect(_on_slider_value_changed.bind("SFX"))
	
	for button in side_bar.get_children():
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
			if DialogSystem.is_active || is_title_scene_active:
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
	continue_button.grab_focus()


func hide_pause_menu() -> void:
	get_tree().paused = false
	visible = false
	is_paused = false
	hidden.emit()


func _quit_to_menu() -> void:
	hide_pause_menu()
	get_tree().change_scene_to_file("res://title_scene/title_scene.tscn")


func _quit_to_desktop() -> void:
	get_tree().quit()


func _on_slider_value_changed(value: float, bus: String) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index(bus), db)
	
	var config = ConfigFile.new()
	config.set_value("audio", "master", master_slider.value)
	config.set_value("audio", "music", music_slider.value)
	config.set_value("audio", "sfx", sfx_slider.value)
	config.save("user://settings.cfg")


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
