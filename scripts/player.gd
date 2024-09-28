extends CharacterBody2D

const walk_speed = 24
const sprint_speed = 36
const direction_to_vector = {
	"ui_up": Vector2.UP,
	"ui_left": Vector2.LEFT,
	"ui_right": Vector2.RIGHT,
	"ui_down": Vector2.DOWN,
}

var vector
var direction = "ui_down"
var direction_history = []
@onready var anim = $AnimatedSprite2D

func _physics_process(_delta: float) -> void:
	for input in direction_to_vector.keys():
		if Input.is_action_just_released(input):
			var index = direction_history.find(input)
			if index != -1:
				direction_history.remove_at(index)
				
		if Input.is_action_just_pressed(input):
			direction_history.append(input)
			
		if !direction_history.is_empty() :
			direction = direction_history[direction_history.size() - 1]
			if Input.is_action_pressed("sprint"):
				anim.play(direction.erase(0, 3) + "_walk")
				velocity = direction_to_vector[direction] * sprint_speed
			else:
				anim.play(direction.erase(0, 3) + "_walk")
				velocity = direction_to_vector[direction] * walk_speed
		else:
			anim.play(direction.erase(0, 3) + "_idle")
			velocity = Vector2.ZERO
			
		move_and_slide()
