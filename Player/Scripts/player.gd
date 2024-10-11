class_name Player extends CharacterBody2D

const direction_to_vector = {
	"up": Vector2.UP,
	"left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"down": Vector2.DOWN,
}

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var direction_history = []

@onready var animation_player : AnimationPlayer = $AnimationPlayer
@onready var sprite : Sprite2D = $Sprite2D
@onready var state_machine : PlayerStateMachine = $StateMachine

signal DirectionChanged( new_direction: Vector2 )

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.Initialize(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta : float ) -> void:
	for input in direction_to_vector.keys():
		if Input.is_action_just_pressed(input):
			direction_history.append(input)
		if Input.is_action_just_released(input):
			var index = direction_history.find(input)
			if index != -1:
				direction_history.remove_at(index)
	
	if !direction_history.is_empty() :
		direction = direction_to_vector[direction_history[direction_history.size() - 1]]
	else:
		direction = Vector2.ZERO
	pass


func _physics_process( _delta: float ) -> void:
	move_and_slide()


func SetDirection() -> bool:
	var new_dir : Vector2 = direction
	if direction == Vector2.ZERO:
		return false
	
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit( new_dir )
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true


func UpdateAnimation( state : String ) -> void:
	animation_player.play( state + "_" + AnimDirection() )
	pass


func AnimDirection() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
