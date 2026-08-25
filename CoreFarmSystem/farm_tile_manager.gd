# This scene manages all the tile (grass, dirt, tilled etc) related info and visuals, placing and removing them
extends Node2D
class_name FarmTileManager

@export var background_tiles: TileMapLayer
@export var main_tiles: TileMapLayer

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
	#dirt_tiles.set_cell(mapped_coord, tile_lookup.tilled[0], tile_lookup.tilled[1])
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.tilled[0], tile_lookup.tilled[1])
	
func dig_ground() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	#main_tiles.set_cell(mapped_coord, tile_lookup.dirt[0], tile_lookup.dirt[1])
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.dirt[0], tile_lookup.dirt[1])
	
func water_ground() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	#main_tiles.set_cell(mapped_coord, tile_lookup.watered[0], tile_lookup.watered[1])
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.watered[0], tile_lookup.watered[1])

func grow_grass() -> void:
	var mapped_coord := get_mapped_coord(get_global_mouse_position())
	#main_tiles.set_cell(mapped_coord, tile_lookup.grass[0], tile_lookup.grass[1])
	main_tiles.set_cells_terrain_connect([mapped_coord], tile_lookup.grass[0], tile_lookup.grass[1])
