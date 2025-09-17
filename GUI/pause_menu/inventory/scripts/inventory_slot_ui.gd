class_name InventorySlotUI extends Button


var slot_data : SlotData : set = set_slot_data

@onready var texture_rect: TextureRect = $TextureRect


func _ready() -> void:
	texture_rect.texture = null
	focus_entered.connect( item_focused )
	focus_exited.connect( item_unfocused )
	pressed.connect( item_pressed )


func set_slot_data( value : SlotData ) -> void:
	slot_data = value
	if slot_data == null:
		return
	texture_rect.texture = slot_data.item_data.texture


func item_focused() -> void:
	if slot_data != null:
		if slot_data.item_data != null:
			PauseMenu.update_item_description( slot_data.item_data.description )
			PauseMenu.update_item_name( slot_data.item_data.name )
			PauseMenu.update_item_image( slot_data.item_data.image )
	pass


func item_unfocused() -> void:
	PauseMenu.update_item_name( "" )
	PauseMenu.update_item_description( "" )
	PauseMenu.update_item_image( null )
	pass


func item_pressed() -> void:
	if slot_data:
		if slot_data.item_data:
			var was_used = slot_data.item_data.use()
			if PauseMenu.waiting_for_item_use:
				PauseMenu.item_used.emit( slot_data.item_data.name )
			if was_used == false:
				return
			#slot_data.quantity -= 1
