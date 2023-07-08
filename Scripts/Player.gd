extends CharacterBody2D

var plant_seeds = preload("res://Prefabs/Plant.tscn")
var bullet = preload("res://Prefabs/Bullet.tscn")

@export var move_speed = 300
@export var acceleration = 0.2
@export var camera_offset_strength = 100

var move = Vector2(0,0)
var tile_highlight = null
var current_weapon = WeaponEnum.Weapon.DIG

func _process(_delta):
	movement()
	mouselook()
	if Input.is_action_pressed("ShowRadialMenu") and !$Control.visible:
		$Control.visible = true
	elif !Input.is_action_pressed("ShowRadialMenu") and $Control.visible:
		$Control.visible = false

func _input(event):
	if event.is_action_pressed("Fire"):
		if $Control.visible:
			pass
		elif tile_highlight != null:
			shoot_bullet()
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			Music.transition("Song1")
		elif event.keycode == KEY_R:
			Music.transition("Song2")

func shoot_bullet():
	var new_bullet = bullet.instantiate()
	new_bullet.weapon = current_weapon
	add_child(new_bullet)
	new_bullet.transform = $Muzzle.transform
	new_bullet.look_at(get_global_mouse_position())
	new_bullet.destination = get_global_mouse_position()

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

func _on_tile_query_body_shape_entered(body_rid, body, _body_shape_index, _local_shape_index):
	assert(is_instance_valid(GlobalTileMap.map))
	var coords = body.get_coords_for_body_rid(body_rid)
	tile_highlight = coords

func _on_dig_pressed():
	current_weapon = WeaponEnum.Weapon.DIG

func _on_water_pressed():
	current_weapon = WeaponEnum.Weapon.WATER

func _on_plant_pressed():
	current_weapon = WeaponEnum.Weapon.PLANT

func _on_radial_menu_hovered(child):
	%Selection.text = child.name
