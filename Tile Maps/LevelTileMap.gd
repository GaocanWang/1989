class_name LevelTileMap extends Node2D

@onready var largest_layer : TileMapLayer = $Floor


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.ChangeTileMapBounds( GetTilemapBounds() )
	pass # Replace with function body.


func GetTilemapBounds() -> Array[ Vector2 ]:
	var bounds : Array[ Vector2 ]
	bounds.append(
		Vector2( largest_layer.get_used_rect().position * largest_layer.rendering_quadrant_size )
	)
	bounds.append(
		Vector2( largest_layer.get_used_rect().end * largest_layer.rendering_quadrant_size )
	)
	return bounds
