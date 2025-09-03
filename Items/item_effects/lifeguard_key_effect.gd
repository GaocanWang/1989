class_name LifeguardKeyEffect extends ItemEffect

var dialog_items : Array[ DialogItem ] = [DialogText.new()]

func use() -> void:
	if !LevelManager.changeroom_open && LevelManager.near_changeroom:
		PauseMenu.hide_pause_menu()
		PauseMenu.play_audio( load( "res://GUI/dialog_system/audio/key turning sfx.mp3" ) )
		await PauseMenu.tree().create_timer(1.0).timeout
		LevelManager.changeroom_unlocked.emit()
	elif !LevelManager.storage_open && LevelManager.near_storage:
		PauseMenu.hide_pause_menu()
		
		dialog_items[0].text = "The storage room door unlocks."
		dialog_items[0].npc_info = load("res://npc/00_npcs/box.tres")
		
		PauseMenu.play_audio( load( "res://GUI/dialog_system/audio/key turning sfx.mp3" ) )
		LevelManager.storage_open = true
		await PauseMenu.tree().create_timer(1.0).timeout
		DialogSystem.show_dialog( dialog_items )
	else:
		PauseMenu.play_audio( load( "res://GUI/dialog_system/audio/error sfx.mp3" ) )
