extends Sprite2D

@export var growth_timer : float = 1
@export var plant_cycle = []

var tile_coordinates: Vector2i
var current_stage : int = 0 : set = change_stage
var turret_online : bool = false

func _ready():
	$Timer.wait_time = growth_timer
	tile_coordinates = GlobalTileMap.map.local_to_map(position)

func _physics_process(delta):
	if !turret_online:
		return

func change_stage(next_stage):
	current_stage = clamp(next_stage, 0, plant_cycle.size())
	texture = plant_cycle[clamp(current_stage, 0, plant_cycle.size()-1)]

func _on_timer_timeout():
	if turret_online:
		return
	assert(is_instance_valid(GlobalTileMap.map))
	var tile_data = GlobalTileMap.map.get_cell_tile_data(0, tile_coordinates)
	# check if the dirt tile is watered before growing
	var alternative = GlobalTileMap.map.get_cell_alternative_tile(0, tile_coordinates)
	if tile_data.get_custom_data("Type") == 2 and alternative == 0:
		return
	# check that another crop isn't in the way
	if $Area2D.has_overlapping_areas():
		print("Can't Grow")
		return
	
	current_stage += 1
	# after growing all the way, revert to a pre-harvest state and make the dirt dry
	if current_stage == plant_cycle.size():
		turret_online = true
