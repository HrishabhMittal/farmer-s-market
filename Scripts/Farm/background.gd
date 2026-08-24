extends Node2D
@onready var tile_map = $TileMapLayer
@onready var sprite = $Sprite2D

@export var spawn_chance: float = 0.1


var source_id: int = 1


var possible_tiles: Array[Vector2i] = [
	Vector2i(0, 0),
	Vector2i(1, 0),
	Vector2i(2, 0),
	Vector2i(3, 0)
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if sprite.texture == null:
		push_error("No texture assigned to the background Sprite2D!")
		return
	generate_tiles()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func generate_tiles() -> void:
	# get_rect() gets the exact local bounding box of this Sprite2D
	var rect = sprite.get_rect()
	
	# Convert the top-left (position) and bottom-right (end) into grid cells
	var start_cell: Vector2i = tile_map.local_to_map(rect.position)
	var end_cell: Vector2i = tile_map.local_to_map(rect.end)
	
	print("Generating grid from: ", start_cell, " to ", end_cell)
	
	for x in range(start_cell.x, end_cell.x):
		for y in range(start_cell.y, end_cell.y):
			if randf() <= spawn_chance:
				var random_tile = possible_tiles.pick_random()
				tile_map.set_cell(Vector2i(x, y), source_id, random_tile)
