class_name ThirdAct extends Area2D

@onready var buttons: VBoxContainer = $CanvasLayer/VBoxContainer
@onready var y: Button = $CanvasLayer/VBoxContainer/Y
@onready var x: Button = $CanvasLayer/VBoxContainer/X
@onready var teresa: Button = $CanvasLayer/VBoxContainer/Teresa
@onready var shift_partner: Button = $CanvasLayer/VBoxContainer/ShiftPartner

var dialog_items_1 : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_y : Array[ DialogItem ]
var dialog_items_y_2 : Array[ DialogItem ]
var dialog_items_y_3 : Array[ DialogItem ]
var dialog_items_x : Array[ DialogItem ]
var dialog_items_x_2 : Array[ DialogItem ]
var dialog_items_teresa : Array[ DialogItem ]
var dialog_items_partner : Array[ DialogItem ]
var dialog_items_partner_2 : Array[ DialogItem ]
var dialog_items_partner_3 : Array[ DialogItem ]
var dialog_items_wrong : Array[ DialogItem ]
var dialog_items_wrong_y : Array[ DialogItem ]
var dialog_items_wrong_x : Array[ DialogItem ]
var dialog_items_wrong_partner : Array[ DialogItem ]


func _ready() -> void:
	buttons.hide()
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	y.pressed.connect( _on_y )
	x.pressed.connect( _on_x )
	teresa.pressed.connect( _on_teresa )
	shift_partner.pressed.connect( _on_shift_partner )
	
	for c in get_children():
		if c.name == "1":
			for d in c.get_children():
				dialog_items_1.append( d )
		elif c.name == "2":
			for d in c.get_children():
				dialog_items_2.append( d )
		elif c.name == "Y":
			for d in c.get_children():
				dialog_items_y.append( d )
		elif c.name == "Y2":
			for d in c.get_children():
				dialog_items_y_2.append( d )
		elif c.name == "Y3":
			for d in c.get_children():
				dialog_items_y_3.append( d )
		elif c.name == "X":
			for d in c.get_children():
				dialog_items_x.append( d )
		elif c.name == "X2":
			for d in c.get_children():
				dialog_items_x_2.append( d )
		elif c.name == "Teresa":
			for d in c.get_children():
				dialog_items_teresa.append( d )
		elif c.name == "Partner":
			for d in c.get_children():
				dialog_items_partner.append( d )
		elif c.name == "Partner2":
			for d in c.get_children():
				dialog_items_partner_2.append( d )
		elif c.name == "Partner3":
			for d in c.get_children():
				dialog_items_partner_3.append( d )
		elif c.name == "Wrong":
			for d in c.get_children():
				dialog_items_wrong.append( d )
		elif c.name == "WrongY":
			for d in c.get_children():
				dialog_items_wrong_y.append( d )
		elif c.name == "WrongX":
			for d in c.get_children():
				dialog_items_wrong_x.append( d )
		elif c.name == "WrongPartner":
			for d in c.get_children():
				dialog_items_wrong_partner.append( d )
	pass


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _on_y() -> void:
	await get_tree().process_frame	
	buttons.hide()
	DialogSystem.show_dialog( dialog_items_y )
	await DialogSystem.finished
	get_tree().paused = true
	PauseMenu.waiting_for_item_use = true
	while true:
		if await PauseMenu.item_used == "Bloody Sink Piece":
			break
		else:
			DialogSystem.show_dialog( dialog_items_wrong_y )
			await DialogSystem.finished
			get_tree().paused = true
	PauseMenu.waiting_for_item_use = false
	DialogSystem.show_dialog( dialog_items_y_2 )
	await DialogSystem.finished
	PlayerManager.player.sprite2.texture = load( "res://npc/sprites/y.png" )
	PlayerManager.player.sprite.visible = false
	PlayerManager.player.sprite2.visible = true
	get_tree().change_scene_to_file( "res://Levels/Part3/01.tscn" )
	DialogSystem.show_dialog( dialog_items_y_3 )
	pass


func _on_x() -> void:
	await get_tree().process_frame
	buttons.hide()
	DialogSystem.show_dialog( dialog_items_x )
	await DialogSystem.finished
	get_tree().paused = true
	PauseMenu.waiting_for_item_use = true
	while true:
		if await PauseMenu.item_used == "Bloody Sink Piece":
			break
		else:
			DialogSystem.show_dialog( dialog_items_wrong_x )
			await DialogSystem.finished
			get_tree().paused = true
	PauseMenu.waiting_for_item_use = false
	DialogSystem.show_dialog( dialog_items_x_2 )
	pass


func _on_teresa() -> void:
	await get_tree().process_frame
	buttons.hide()
	DialogSystem.show_dialog( dialog_items_teresa )
	await DialogSystem.finished
	get_tree().paused = true
	buttons.show()
	y.grab_focus()
	pass


func _on_shift_partner() -> void:
	await get_tree().process_frame
	buttons.hide()
	DialogSystem.show_dialog( dialog_items_partner )
	await DialogSystem.finished
	get_tree().paused = true
	PauseMenu.waiting_for_item_use = true
	while true:
		if await PauseMenu.item_used == "Bloody Sink Piece":
			break
		else:
			DialogSystem.show_dialog( dialog_items_wrong_partner )
			await DialogSystem.finished
			get_tree().paused = true
	PauseMenu.waiting_for_item_use = false
	DialogSystem.show_dialog( dialog_items_partner_2 )
	await DialogSystem.finished
	get_tree().paused = true
	PauseMenu.waiting_for_item_use = true
	while true:
		if await PauseMenu.item_used == "Employee Handbook":
			break
		else:
			DialogSystem.show_dialog( dialog_items_wrong_partner )
			await DialogSystem.finished
			get_tree().paused = true
	PauseMenu.waiting_for_item_use = false
	DialogSystem.show_dialog( dialog_items_partner_3 )
	pass


func player_interact() -> void:
	await get_tree().process_frame
	DialogSystem.show_dialog( dialog_items_1 )
	await DialogSystem.finished
	get_tree().paused = true
	PauseMenu.waiting_for_item_use = true
	while true:
		if await PauseMenu.item_used == "Employee Handbook":
			break
		else:
			DialogSystem.show_dialog( dialog_items_wrong )
			await DialogSystem.finished
			get_tree().paused = true
	PauseMenu.waiting_for_item_use = false
	AudioManager.play_music( null )
	PauseMenu.play_audio( load( "res://GUI/dialog_system/audio/evidence OR _THIS IS IT!_ SFX.mp3" ) )
	SceneTransition.texture_rect.texture = load( "res://FullScreenArt/this is it fs.png" )
	SceneTransition.texture_rect.show()
	await get_tree().create_timer( 2.0 ).timeout
	SceneTransition.texture_rect.hide()
	DialogSystem.show_dialog( dialog_items_2 )
	await DialogSystem.finished
	get_tree().paused = true
	buttons.show()
	y.grab_focus()
	pass
