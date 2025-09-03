class_name DocumentViewerNode extends CanvasLayer

signal finished

var is_active : bool = false

var pages : Array[ String ] = []
var current_page : int = 0

@onready var text: Label = $Text
@onready var page: Label = $Page


func _ready() -> void:
	hide()
	pass


func _input(event: InputEvent) -> void:
	if is_active:
		if event.is_action_pressed("ui_right"):
			current_page = (current_page + 1) % pages.size()
			update_page()
		elif event.is_action_pressed("ui_left"):
			current_page = (current_page - 1 + pages.size()) % pages.size()
			update_page()
		elif event.is_action_pressed("ui_accept"):
			is_active = false
			hide()
			await get_tree().process_frame
			get_tree().paused = false
			finished.emit()

func show_document( document : Array[ String ] ) -> void:
	get_tree().paused = true
	pages = document
	update_page()
	show()
	is_active = true


func update_page():
	text.text = pages[current_page]
	page.text = "%02d / %02d" % [current_page, pages.size() - 1]
