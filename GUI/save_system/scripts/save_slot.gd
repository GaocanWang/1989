class_name SaveSlot extends Button


var mode : String = "save"




func _ready() -> void:
	self.pressed.connect( _button_pressed )
	pass



func _button_pressed() -> void:
	if mode == "save":
		SaveManager.save_game( name )
	else:
		SaveManager.load_game( name )
	SaveManager.finished.emit()
	pass
