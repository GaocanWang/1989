class_name Follower extends CharacterBody2D

var state : String = "idle"
var direction : Vector2 = Vector2.DOWN
var direction_name : String = "down"
var prev_direction_name : String = ""

@export var spritesheet : Texture2D
@export var distance : int

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	sprite.texture = spritesheet
	update_animation()
	pass


func _process(delta: float) -> void:
	if PlayerManager.past_positions[ distance ] != null:
		direction = ( PlayerManager.past_positions[ distance ] - global_position ).normalized()
		update_direction()
		if ( direction.length() <= 0.1 && state != "idle"):
			state = "idle"
			update_animation()
		elif ( direction.length() > 0.1 && state != "walk" ):
			state = "walk"
			update_animation()
		if ( direction_name != prev_direction_name ):
			prev_direction_name = direction_name
			update_animation()
		global_position = global_position.move_toward(PlayerManager.past_positions[ distance ], 80.0 * delta)
	pass


func update_direction():
	if ( direction.y < -0.5 ):
		direction_name = "up"
	elif ( direction.y > 0.5 ):
		direction_name = "down"
	elif ( direction.x > 0.5):
		direction_name = "right"
	elif ( direction.x < -0.5 ):
		direction_name = "left"


func update_animation():
	animation_player.play( state + "_" + direction_name )
