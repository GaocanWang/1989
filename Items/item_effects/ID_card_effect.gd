class_name IDEffect extends ItemEffect

func use() -> void:
	if PauseMenu.waiting_for_item_use:
		PauseMenu.hide_pause_menu()
