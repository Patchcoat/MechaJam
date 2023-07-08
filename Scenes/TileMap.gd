extends TileMap

var tile_state = {}

func _ready():
	GlobalTileMap.map = self

func make_dirt(cordinates):
	# erase grass
	set_cell(1, cordinates)
	# place the dirt
	set_cell(0, cordinates, 1, Vector2i(4, 21))

func plant_seed(coordinates, seed):
	pass

func water_dirt(cordinates):
	set_cell(0, cordinates, 1, Vector2i(4, 21), 1)

func dry_dirt(cordinates):
	set_cell(0, cordinates, 1, Vector2i(4, 21), 0)
