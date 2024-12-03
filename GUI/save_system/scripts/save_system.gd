class_name CanvasLayerNode extends CanvasLayer

signal finished

var is_active : bool = false

@onready var save_slots: VBoxContainer = $Control/PanelContainer/VBoxContainer




func _ready() -> void:
	hide_UI()
	pass



func _unhandled_input(event: InputEvent) -> void:
	if is_active == false:
		return
	pass



func show_UI( mode : String ) -> void:
	is_active = true
	for c in save_slots.get_children():
		c.mode = mode
	visible = true
	pass



func hide_UI() -> void:
	is_active = false
	visible = false
	pass
