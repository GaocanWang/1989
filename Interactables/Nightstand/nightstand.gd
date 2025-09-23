class_name Nightstand extends Area2D

@onready var buttons: VBoxContainer = $CanvasLayer/VBoxContainer
@onready var yes: Button = $CanvasLayer/VBoxContainer/Button
@onready var no: Button = $CanvasLayer/VBoxContainer/Button2
@onready var texture: TextureRect = $CanvasLayer/TextureRect

var showing : bool = false
var dialog_items : Array[ DialogItem ]
var dialog_items_repeat : Array[ DialogItem ]


func _ready() -> void:
	buttons.hide()
	texture.hide()
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	yes.pressed.connect( _on_yes )
	no.pressed.connect( _on_no )
	
	for c in get_children():
		if c is DialogItem:
			dialog_items.append( c )
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") && showing == true:
		texture.hide()
		showing = false
		get_tree().paused = false



func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	pass


func _on_yes() -> void:
	buttons.hide()
	texture.show()
	showing = true
	pass


func _on_no() -> void:
	buttons.hide()	
	get_tree().paused = false
	pass


func player_interact() -> void:
	await get_tree().process_frame
	DialogSystem.show_dialog( dialog_items )
	await DialogSystem.finished
	get_tree().paused = true
	buttons.show()
	yes.grab_focus()
	pass
