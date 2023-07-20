extends Node2D

@export var growth_timer : float = 1
@export var plant_cycle = []

var tile_coordinates: Vector2i
var turret_online : bool = false

func _ready():
	tile_coordinates = GlobalTileMap.map.local_to_map(position)

func _physics_process(delta):
	if !turret_online:
		return

func _on_animation_player_animation_finished(anim_name):
	print(anim_name)
	if anim_name == "TurretSmall":
		assert(is_instance_valid(GlobalTileMap.map))
		var tile_data = GlobalTileMap.map.get_cell_tile_data(0, tile_coordinates)
		# check if the dirt tile is watered before growing
		var alternative = GlobalTileMap.map.get_cell_alternative_tile(0, tile_coordinates)
		if tile_data.get_custom_data("Type") == 2 and alternative == 0:
			return
		$AnimationPlayer.play("TurretGrow")
	if anim_name == "TurretBig":
		return
	if anim_name == "TurretGrow":
		turret_online = true
		$AnimationPlayer.play("TurretBig")
		return
	assert(is_instance_valid(GlobalTileMap.map))
	var tile_data = GlobalTileMap.map.get_cell_tile_data(0, tile_coordinates)
	# check if the dirt tile is watered before growing
	var alternative = GlobalTileMap.map.get_cell_alternative_tile(0, tile_coordinates)
	if tile_data.get_custom_data("Type") == 2 and alternative == 0:
		return
