class_name ExtraDialogue extends Node

var dialog_items : Array[ DialogItem ]


func _ready() -> void:
	for c in get_children():
		dialog_items.append( c )
	
	LevelManager.extra_dialogue.connect( show_extra_dialogue )


func show_extra_dialogue() -> void:
	DialogSystem.show_dialog( dialog_items )
