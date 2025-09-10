extends CanvasLayer

const SAVE_PATH = "user://"

signal game_loaded
signal game_saved

@onready var button: Button = $Control/VBoxContainer/Button
@onready var button_2: Button = $Control/VBoxContainer/Button2
@onready var button_3: Button = $Control/VBoxContainer/Button3


var current_save : Dictionary = {
	scene_path = "",
	player = {
		pos_x = 0,
		pos_y = 0
	},
	items = [],
	persistence = [],
	quests = [],
}


func _ready() -> void:
	hide()


func show_save_menu( mode : String ) -> void:
	get_tree().paused = true
	
	if mode == "save":
		button.pressed.connect( save_game.bind("save.sav") )
		button_2.pressed.connect( save_game.bind("save2.sav") )
		button_3.pressed.connect( save_game.bind("save3.sav") )
	elif mode == "load":
		button.pressed.connect( load_game.bind("save.sav") )
		button_2.pressed.connect( load_game.bind("save2.sav") )
		button_3.pressed.connect( load_game.bind("save3.sav") )
	
	show()
	button.grab_focus()


func save_game( path : String ) -> void:
	hide()
	get_tree().paused = false
	
	update_player_data()
	update_scene_path()
	update_item_data()
	var file := FileAccess.open( SAVE_PATH + path, FileAccess.WRITE )
	var save_json = JSON.stringify( current_save )
	file.store_line( save_json )
	game_saved.emit()
	pass


func get_save_file( path : String ) -> FileAccess:
	return FileAccess.open( SAVE_PATH + path, FileAccess.READ )


func load_game( path : String ) -> void:
	hide()
	get_tree().paused = false
	
	var file := get_save_file( path )
	var json := JSON.new()
	json.parse( file.get_line() )
	var save_dict : Dictionary = json.get_data() as Dictionary
	current_save = save_dict
	
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	
	await LevelManager.level_load_started
	
	PlayerManager.set_player_position( Vector2( current_save.player.pos_x, current_save.player.pos_y ) )
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	
	await LevelManager.level_loaded
	
	game_loaded.emit()
	pass


func update_player_data() -> void:
	var p : Player = PlayerManager.player
	current_save.player.pos_x = p.global_position.x
	current_save.player.pos_y = p.global_position.y


func update_scene_path() -> void:
	var p : String = ""
	for c in get_tree().root.get_children():
		if c is Level:
			p = c.scene_file_path
	current_save.scene_path = p


func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()


func add_persistent_value( value : String) -> void:
	if check_persistent_value( value ) == false:
		current_save.persistence.append( value )
	pass


func check_persistent_value( value : String ) -> bool:
	var p = current_save.persistence as Array
	return p.has( value )
