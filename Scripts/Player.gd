extends CharacterBody2D

@export var move_speed = 300
@export var acceleration = 0.2
@export var camera_offset_strength = 100

var move = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	movement()
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
