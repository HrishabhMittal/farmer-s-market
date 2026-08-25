# This scene manages all the tile (grass, dirt, tilled etc) related info and visuals, placing and removing them
extends Node2D
class_name FarmTileManager

@export var background_tiles: TileMapLayer
@export var main_tiles: TileMapLayer
var planted_tiles: Dictionary[Vector2i, bool] = {}

var tile_lookup: Dictionary[String, Array] = {
	"grass": [0, 0],
	"dirt": [0, 1],
	"tilled": [0, 2],
	"watered": [0, 3]
}

func get_tile_type(world_coord: Vector2) -> String:
	# Get the tile at that coordinate
	var mapped_coord: Vector2i = get_mapped_coord(world_coord)
	
	# Get tiledata
	var tiledata: TileData = main_tiles.get_cell_tile_data(mapped_coord)
	if tiledata == null: # If it is null, that means there is no tile at tha location
		return "none"
	
	# Return the tile_type custom data. It was set in the Tilerset editor
	return tiledata.get_custom_data("tile_type")

func get_mapped_coord(world_coord: Vector2) -> Vector2i:
	# Convert world coordinate to the local coordinate of the tilemaplayer
	var local_coord: Vector2 = main_tiles.to_local(world_coord)
	
	# Get the tile at that coordinate and return
	return main_tiles.local_to_map(local_coord)
	
func till_ground() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.tilled[0], tile_lookup.tilled[1])
	
func dig_ground() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.dirt[0], tile_lookup.dirt[1])
	
func water_ground() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.watered[0], tile_lookup.watered[1])

func grow_grass() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.grass[0], tile_lookup.grass[1])

func get_tile_center(world_coord: Vector2) -> Vector2:
	var mapped_coord := get_mapped_coord(world_coord)
	return main_tiles.map_to_local(mapped_coord)
	
func is_crop_planted(world_coord: Vector2) -> bool:
	var mapped_coord := get_mapped_coord(world_coord)
	
	# Get tiledata
	var tiledata: TileData = main_tiles.get_cell_tile_data(mapped_coord)
	if tiledata == null: # If it is null, that means there is no tile at tha location
		return true # This condition should not be true though
	
	# Return the tile_type custom data. It was set in the Tilerset editor
	#return tiledata.get_custom_data("is_crop_planted")
	return planted_tiles.get(mapped_coord, false)

func crop_planted(world_coord: Vector2) -> void:
	#print_planted_crops()
	var mapped_coord := get_mapped_coord(world_coord)
	#prints("mapped_coord ", mapped_coord)
	
	# Get tiledata
	var tiledata: TileData = main_tiles.get_cell_tile_data(mapped_coord)
	if tiledata == null: # If it is null, that means there is no tile at tha location
		push_error("Planted crop on a non existing tile")
		return # This condition should not be true though
	
	# Return the tile_type custom data. It was set in the Tilerset editor
	#prints("Crop Planted Called")
	#tiledata.set_custom_data("is_crop_planted", true)
	planted_tiles[mapped_coord] = true
	#print_planted_crops()
	
func remove_crop(world_coord: Vector2) -> void:
	#print_planted_crops()
	var mapped_coord := get_mapped_coord(world_coord)
	#prints("mapped_coord ", mapped_coord)
	
	# Get tiledata
	var tiledata: TileData = main_tiles.get_cell_tile_data(mapped_coord)
	if tiledata == null: # If it is null, that means there is no tile at tha location
		push_error("Planted crop on a non existing tile")
		return # This condition should not be true though
	
	# Return the tile_type custom data. It was set in the Tilerset editor
	#prints("Crop Planted Called")
	#tiledata.set_custom_data("is_crop_planted", true)
	planted_tiles[mapped_coord] = false
	#print_planted_crops()
	
func print_planted_crops() -> void:
	for coords in main_tiles.get_used_cells():
		var tile_data: TileData = main_tiles.get_cell_tile_data(coords)
		if tile_data:
			var is_planted: bool = tile_data.get_custom_data("is_crop_planted")
			print("Tile at ", coords, " | is_crop_planted: ", is_planted)

func _ready():
	SignalBus.crop_harvested.connect(_on_crop_harvested)
	#SignalBus.day_ended.connect(unwater_all_tiles)
	
func _on_crop_harvested(farm_plant: FarmPlant) -> void:
	remove_crop(farm_plant.global_position)

func unwater_tile(world_coord: Vector2) -> void:
	var mapped_coord := get_mapped_coord(world_coord)
	main_tiles.set_cells_terrain_connect(
		[mapped_coord], 
		tile_lookup.tilled[0], 
		tile_lookup.tilled[1]
	)
	
func untill_tile(world_coord: Vector2) -> void:
	var mapped_coord := get_mapped_coord(world_coord)
	main_tiles.set_cells_terrain_connect(
		[mapped_coord], 
		tile_lookup.dirt[0], 
		tile_lookup.dirt[1]
	)

func unwater_all_tiles() -> void:
	var tiles_to_unwater: Array[Vector2i] = []

	for coords in main_tiles.get_used_cells():
		var tiledata: TileData = main_tiles.get_cell_tile_data(coords)
		if tiledata and tiledata.get_custom_data("tile_type") == "watered":
			tiles_to_unwater.append(coords)

	if not tiles_to_unwater.is_empty():
		main_tiles.set_cells_terrain_connect(
			tiles_to_unwater, 
			tile_lookup.tilled[0], 
			tile_lookup.tilled[1]
		)
