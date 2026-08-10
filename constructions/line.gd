class_name Line extends Node2D

@export var point_1 : Vector2
@export var point_2 : Vector2
@export var color : Color
@export var display_width : float = 2

func _draw() -> void:
	draw_line(point_1+position,point_2+position,color,display_width,true)

func is_equal(line : Line) -> bool:
	# Check if points are approximately equal - make sure to check both orientations
	if is_equal_approx(point_1.x,line.point_1.x) and \
		is_equal_approx(point_1.y,line.point_1.y) and \
		is_equal_approx(point_2.x,line.point_2.x) and \
		is_equal_approx(point_2.y,line.point_2.y):
		return true
	elif is_equal_approx(point_1.x,line.point_2.x) and \
		is_equal_approx(point_1.y,line.point_2.y) and \
		is_equal_approx(point_2.x,line.point_1.x) and \
		is_equal_approx(point_2.y,line.point_1.y):
		return true
	else:
		return false

func is_parallel(line : Line) -> bool:
	if is_equal_approx(point_1.x,point_2.x):
		if is_equal_approx(line.point_1.x,line.point_2.x):
			return true
		else:
			return false
	elif is_equal_approx((point_2.y-point_1.y)/(point_2.x-point_1.x), \
		(line.point_2.y-line.point_1.y)/(line.point_2.x-line.point_1.x)):
			return true
	else:
		return false
