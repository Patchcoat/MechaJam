extends CollisionShape2D

var top_left : Vector2
var bottom_right : Vector2

func _draw():
	var width = shape.size.x
	var height = shape.size.y
	top_left = Vector2(-width/2, -height/2)
	bottom_right = Vector2(width, height)
	draw_rect(Rect2(top_left.x, top_left.y,\
		bottom_right.x, bottom_right.y), Color.GREEN, false, 2.0)
