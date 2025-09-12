class_name MapEffect extends ItemEffect


func use() -> void:
	PauseMenu.hide_pause_menu()
	PauseMenu.play_audio( load("res://Interactables/MapHolder/SFX paper.mp3") )
	SceneTransition.show_image( load("res://Interactables/MapHolder/pool map fs.png") )
	pass
