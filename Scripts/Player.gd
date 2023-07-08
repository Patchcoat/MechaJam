extends CharacterBody2D

enum {DIG, PLANT, WATER}

var plant_seeds = preload("res://Prefabs/Plant.tscn")

@export var move_speed = 300
@export var acceleration = 0.2
@export var camera_offset_strength = 100

var move = Vector2(0,0)
var tile_highlight = null
var current_weapon = DIG

func _process(delta):
	movement()
	mouselook()
	if Input.is_action_pressed("ShowRadialMenu") and !$Control.visible:
		$Control.visible = true
	elif !Input.is_action_pressed("ShowRadialMenu") and $Control.visible:
		$Control.visible = false

func _input(event):
	if event.is_action_pressed("Select"):
		if $Control.visible:
			pass
		elif tile_highlight != null:
			select()

func select():
	assert(is_instance_valid(GlobalTileMap.map))
	var layer = 2
	var tile_data = GlobalTileMap.map.get_cell_tile_data(layer, tile_highlight)
	# don't select a tile if it's on the overlay layer
	if is_instance_valid(tile_data):
		return
	layer -= 1
	tile_data = GlobalTileMap.map.get_cell_tile_data(layer, tile_highlight)
	# check that the grass exists
	if !is_instance_valid(tile_data):
		# if not, select the dirt
		layer -= 1
		tile_data = GlobalTileMap.map.get_cell_tile_data(layer, tile_highlight)
	var tile_type = tile_data.get_custom_data("Type")
	print(tile_type)
	# digging grass
	if current_weapon == DIG and tile_type == 1:
		GlobalTileMap.map.make_dirt(tile_highlight)
	# watering dirt
	if current_weapon == WATER and tile_type == 2:
		GlobalTileMap.map.water_dirt(tile_highlight)
	# planting
	if current_weapon == PLANT and tile_type == 2:
		var new_plant = plant_seeds.instantiate()
		new_plant.position = GlobalTileMap.map.map_to_local(tile_highlight)
		GlobalTileMap.map.add_child(new_plant)

func mouselook():
	var mouse_position = get_viewport().get_mouse_position() / get_viewport().get_visible_rect().size
	mouse_position = mouse_position * 2 - Vector2(1,1)
	$Camera2D.offset = mouse_position * camera_offset_strength

func movement():
	if Input.is_action_pressed("MoveUp"):
		move.y = -1
	elif Input.is_action_pressed("MoveDown"):
		move.y = 1
	else:
		move.y = 0
	if Input.is_action_pressed("MoveLeft"):
		move.x = -1
	elif Input.is_action_pressed("MoveRight"):
		move.x = 1
	else:
		move.x = 0
	velocity.x = lerp(velocity.x, move.x * move_speed, acceleration)
	velocity.y = lerp(velocity.y, move.y * move_speed, acceleration)
	move_and_slide()

func _on_tile_query_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	assert(is_instance_valid(GlobalTileMap.map))
	var coords = body.get_coords_for_body_rid(body_rid)
	tile_highlight = coords

func _on_dig_pressed():
	print("Dig")
	current_weapon = DIG

func _on_water_pressed():
	print("Water")
	current_weapon = WATER

func _on_plant_pressed():
	print("Plant")
	current_weapon = PLANT

func _on_radial_menu_hovered(child):
	%Selection.text = child.name
