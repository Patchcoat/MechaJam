extends Weapon

var missile = preload("res://Prefabs/Projectiles/Missile.tscn")

var start_position : Vector2
var current_position : Vector2
var tiles : Array
var packed_positions : PackedVector2Array
var positions : Array
var firing : bool = false
var rotation_speed : float = 0.5
var crosshair_rotation : float = 0
var missile_index : int = 0

var missle_count : int = 0
var player_ref

func _ready():
	%CollisionShape2D.disabled = true

func _physics_process(delta):
	crosshair_rotation += rotation_speed * 2 * PI * delta

func press(player) -> void:
	if firing or player.missiles <= 0:
		return
	missle_count = player.missiles
	start_position = get_global_mouse_position()
	%CollisionShape2D.shape.size = Vector2(0,0)
	%CollisionShape2D.global_position = start_position
	%CollisionShape2D.disabled = false
	%CollisionShape2D.visible = true
	$Crosshairs.multimesh.instance_count = 0
	$Crosshairs.visible = true

func farm_target():
	current_position = get_global_mouse_position()
	var width = abs(current_position.x - start_position.x)
	var height = abs(current_position.y - start_position.y)
	%CollisionShape2D.shape.size = Vector2(width,height)
	%CollisionShape2D.global_position = start_position.lerp(current_position, 0.5)
	# TODO query all the shapes colliding with the area and maintain a list of them
	var rect = Rect2(start_position.lerp(current_position, 0.5), Vector2(width,height))
	var top_left = rect.position - (rect.size/2)
	var bottom_right = rect.position + (rect.size/2)
	var data = GlobalTileMap.map.get_overlapping_tiles(top_left, bottom_right, 1)
	tiles = data[0]
	packed_positions = data[1]
	packed_positions.resize(missle_count)
	var instances : int = packed_positions.size()
	$Crosshairs.global_position = Vector2(0,0)
	$Crosshairs.multimesh.instance_count = instances
	for i in range(0, instances):
		var new_transform : Transform2D = Transform2D(crosshair_rotation, packed_positions[i])
		$Crosshairs.multimesh.set_instance_transform_2d(i, new_transform)

func enemy_target():
	pass

func hold(player) -> void:
	if firing or player.missiles <= 0:
		return
	if farming:
		farm_target()
	else:
		enemy_target()

func farm_fire():
	current_position = get_global_mouse_position()
	%CollisionShape2D.shape.size = Vector2(0,0)
	%CollisionShape2D.disabled = true
	%CollisionShape2D.visible = false
	$Crosshairs.visible = false
	positions = packed_positions

func enemy_fire():
	pass

func release(player) -> void:
	if firing or player.missiles <= 0:
		return
	if farming:
		farm_fire()
	elif !farming:
		enemy_fire()
	if positions.size() == 0:
		return
	positions.resize(missle_count)
	positions.shuffle()
	$Timer.start()
	firing = true
	player_ref = player

func _on_timer_timeout():
	if missile_index >= positions.size() and player_ref.missiles <= 0:
		$Timer.stop()
		firing = false
		missile_index = 0
		return
	player_ref.missiles -= 1
	var new_missile = missile.instantiate()
	new_missile.weapon = WeaponEnum.Weapon.DIG
	get_parent().get_parent().get_parent().add_child(new_missile)
	fire_missile(new_missile, global_transform, randf_range(0, 2 * PI), positions[missile_index])
	missile_index += 1
