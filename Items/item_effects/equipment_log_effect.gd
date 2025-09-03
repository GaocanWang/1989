class_name EquipmentLogEffect extends ItemEffect

var document : Array[String] = ["Kickboards (14)\nNoodles (20)\nTowel (8)", 
								"11:00 AM\nJ. Ji\n1 Kickboard taken", 
								"2:00 PM\nY. Gurt\n2 Noodles taken", 
								"2:35 PM\nK. Fern\n1 Noodle taken"]

func use() -> void:
	PauseMenu.hide_pause_menu()
	DocumentViewer.show_document(document)
	if PauseMenu.tree().current_scene.name == "09":
		await DocumentViewer.finished
		LevelManager.extra_dialogue.emit()
