class_name ValveSystem extends Area2D

@onready var GUI: TextureRect = $CanvasLayer/TextureRect
@onready var top: ValveContainer = $CanvasLayer/TextureRect/ValveContainer
@onready var right: ValveContainer = $CanvasLayer/TextureRect/ValveContainer2
@onready var bottom: ValveContainer = $CanvasLayer/TextureRect/ValveContainer3
@onready var left: ValveContainer = $CanvasLayer/TextureRect/ValveContainer4
@onready var buttons: VBoxContainer = $CanvasLayer/VBoxContainer
@onready var yes: Button = $CanvasLayer/VBoxContainer/Button
@onready var no: Button = $CanvasLayer/VBoxContainer/Button2

var dialog_items_1 : Array[ DialogItem ]
var dialog_items_2 : Array[ DialogItem ]
var dialog_items_3 : Array[ DialogItem ]


func _ready() -> void:
	GUI.hide()
	buttons.hide()
	
	area_entered.connect( _on_area_enter )
	area_exited.connect( _on_area_exit )
	
	yes.pressed.connect( _on_yes )
	no.pressed.connect( _on_no )
	
	for c in get_children():
		for d in c.get_children():
			if c.name == "1":
				dialog_items_1.append( d )
			elif c.name == "2":
				dialog_items_2.append( d )
			elif c.name == "3":
				dialog_items_3.append( d )
	
	pass


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed( "ui_up" ):
		top.run()
	if Input.is_action_just_pressed( "ui_right" ):
		right.run()
	if Input.is_action_just_pressed( "ui_down" ):
		bottom.run()
	if Input.is_action_just_pressed( "ui_left" ):
		left.run()


func _on_area_enter( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.connect( player_interact )
	LevelManager.near_valve = true
	pass


func _on_area_exit( _a : Area2D ) -> void:
	PlayerManager.interact_pressed.disconnect( player_interact )
	LevelManager.near_valve = false
	pass


func player_interact() -> void:
	if ( !LevelManager.flags.puzzle_solved ):
		if LevelManager.flags.valve_unlocked:
			get_tree().paused = true
			buttons.show()
			yes.grab_focus()
		else:
			DialogSystem.show_dialog( dialog_items_1 )
	pass


func _on_yes() -> void:
	buttons.hide()
	DialogSystem.show_dialog( dialog_items_2 )
	await DialogSystem.finished
	get_tree().paused = true
	GUI.show()
	stage1()
	pass


func _on_no() -> void:
	buttons.hide()	
	get_tree().paused = false
	pass


func stage1() -> void:
	GUI.texture = load( "res://Interactables/ValveSystem/puzzle1.png" )
	top.set_container( 3, 4, [ right, bottom, left ] )
	right.set_container( 0, 2, [ top ] )
	bottom.set_container( 0, 2, [ top, left ] )
	left.set_container( 1, 2, [ top, bottom ] )
	await bottom.full
	stage2()


func stage2() -> void:
	GUI.texture = load( "res://Interactables/ValveSystem/puzzle2.png" )
	top.set_container( 1, 1, [ right ] )
	right.set_container( 0, 2, [ top, bottom, left ] )
	bottom.set_container( 0, 2, [ right, left ] )
	left.set_container( 2, 4, [ right, bottom ] )
	await bottom.full
	stage3()


func stage3() -> void:
	GUI.texture = load( "res://Interactables/ValveSystem/puzzle3.png" )
	top.set_container( 2, 4, [ right, bottom, left ] )
	right.set_container( 0, 2, [ top, bottom ] )
	bottom.set_container( 0, 2, [ top, right, left ] )
	left.set_container( 2, 2, [ top, bottom ] )
	await bottom.full
	GUI.hide()
	LevelManager.flags.puzzle_solved = true
	DialogSystem.show_dialog( dialog_items_3 )
