class_name MaintenanceKeyEffect extends ItemEffect

var dialog_items : Array[DialogItem] = [DialogText.new(), DialogText.new(), DialogText.new()]

func use() -> void:
	if !LevelManager.flags.valve_unlocked && LevelManager.near_valve:
		PauseMenu.hide_pause_menu()
	
		dialog_items[0].text = "“That should do it.”"
		dialog_items[0].npc_info = load( "res://npc/00_npcs/amelia.tres" )
		dialog_items[0].frame = 12
		dialog_items[1].text = "“I found these maintenance keys in the staff lounge.”"
		dialog_items[1].npc_info = load( "res://npc/00_npcs/amelia.tres" )
		dialog_items[1].frame = 2
		dialog_items[2].text = "“Guess the valves can be turned now.”"
		dialog_items[2].npc_info = load( "res://npc/00_npcs/amelia.tres" )
		dialog_items[2].frame = 1
	
		PauseMenu.play_audio( load( "res://GUI/dialog_system/audio/key turning sfx.mp3" ) )
		await PauseMenu.tree().create_timer(1.0).timeout
		DialogSystem.show_dialog( dialog_items )
		LevelManager.flags.valve_unlocked = true
	else:
		PauseMenu.play_audio( load( "res://GUI/dialog_system/audio/error sfx.mp3" ) )
