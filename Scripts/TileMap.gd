extends TileMap

var tile_state = {}

func _ready():
	GlobalTileMap.map = self

func make_dirt(cordinates):
	# erase grass
	set_cell(1, cordinates)
	# place the dirt
	set_cell(0, cordinates, 1, Vector2i(4, 21))

func plant_seed(coordinates, plant):
	if tile_state.has(coordinates) or plant == null:
		return
	var new_plant = plant.instantiate()
	new_plant.position = map_to_local(coordinates)
	GlobalTileMap.map.add_child(new_plant)
	tile_state[coordinates] = true

func use_tilemap(world_coordinate, current_weapon, seeds = null):
	var tile_coordinate = local_to_map(to_local(world_coordinate))
	var layer = 2
	var tile_data = get_cell_tile_data(layer, tile_coordinate)
	# don't select a tile if it's on the overlay layer
	if is_instance_valid(tile_data):
		return
	layer -= 1
	tile_data = get_cell_tile_data(layer, tile_coordinate)
	# check that the grass exists
	if !is_instance_valid(tile_data):
		# if not, select the dirt
		layer -= 1
		tile_data = get_cell_tile_data(layer, tile_coordinate)
	var tile_type = tile_data.get_custom_data("Type")
	# digging grass
	if current_weapon == WeaponEnum.Weapon.DIG and tile_type == 1:
		make_dirt(tile_coordinate)
	# watering dirt
	if current_weapon == WeaponEnum.Weapon.WATER and tile_type == 2:
		water_dirt(tile_coordinate)
	# planting
	if current_weapon == WeaponEnum.Weapon.PLANT and tile_type == 2:
		plant_seed(tile_coordinate, seeds)

func get_overlapping_tiles(top_left, bottom_right, layer) -> Array:
	var tiles = []
	var positions : PackedVector2Array = []
	var top_left_tile = local_to_map(to_local(top_left))
	var bottom_right_tile = local_to_map(to_local(bottom_right))
	for x in range(top_left_tile.x, bottom_right_tile.x):
		for y in range(top_left_tile.y, bottom_right_tile.y):
			var tile_coordinate = Vector2(x, y)
			tiles.append(get_cell_tile_data(layer, tile_coordinate))
			positions.append(to_global(map_to_local(tile_coordinate)))
	return [tiles, positions]

func water_dirt(cordinates):
	set_cell(0, cordinates, 1, Vector2i(4, 21), 1)

func dry_dirt(cordinates):
	set_cell(0, cordinates, 1, Vector2i(4, 21), 0)
