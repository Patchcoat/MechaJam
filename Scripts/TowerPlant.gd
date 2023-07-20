extends Sprite2D

@export var growth_timer : float = 1
@export var plant_cycle = []

var tile_coordinates: Vector2i
var current_stage : int = 0 : set = change_stage
var turret_online : bool = false

func _ready():
	tile_coordinates = GlobalTileMap.map.local_to_map(position)

func _physics_process(delta):
	if !turret_online:
		return

func change_stage(next_stage):
	current_stage = clamp(next_stage, 0, plant_cycle.size())
	texture = plant_cycle[clamp(current_stage, 0, plant_cycle.size()-1)]

func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "TurretSmall":
		return
	if anim_name == "TurretBig":
		return
	if anim_name == "TurretGrow":
		return
	assert(is_instance_valid(GlobalTileMap.map))
	var tile_data = GlobalTileMap.map.get_cell_tile_data(0, tile_coordinates)
	# check if the dirt tile is watered before growing
	var alternative = GlobalTileMap.map.get_cell_alternative_tile(0, tile_coordinates)
	if tile_data.get_custom_data("Type") == 2 and alternative == 0:
		return
	if current_stage == plant_cycle.size():
		turret_online = true
