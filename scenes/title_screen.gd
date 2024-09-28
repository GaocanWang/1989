extends Control

func _ready() -> void:
	$VBoxContainer/Continue.grab_focus()

func _on_continue_pressed() -> void:
	pass

func _on_new_game_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/world.tscn")

func _on_settings_pressed() -> void:
	pass

func _on_quit_pressed() -> void:
	get_tree().quit()
