class_name ValveContainer extends Area2D

signal full

var current_capacity : int
var max_capacity : int
var connected_containers : Array[ValveContainer] = []

@onready var sprite: Sprite2D = $Sprite2D


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		pass


func percentage_full() -> float:
	return float(current_capacity) / float(max_capacity)


func set_container( current : int, maximum : int, connections : Array[ValveContainer] ) -> void:
	current_capacity = 0
	max_capacity = maximum
	connected_containers = connections
	add(current)


func add( amount : int ):
	current_capacity += amount
	
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(sprite, "position:x", lerp(-150, 150, percentage_full()), 0.5)
	await get_tree().create_timer(0.5).timeout
	
	if current_capacity == max_capacity:
		full.emit()


func pick_best() -> ValveContainer:
	var sorted = connected_containers.duplicate()
	sorted.sort_custom(func(a: ValveContainer, b: ValveContainer) -> bool:
		if a.percentage_full() == b.percentage_full():
			return a.max_capacity > b.max_capacity
		return a.percentage_full() < b.percentage_full()
	)
	return sorted[0]


func run() -> void:
	if connected_containers.size() == current_capacity:
		for c in connected_containers:
			c.add(1)
	else:
		pick_best().add(current_capacity)
	add(-current_capacity)
