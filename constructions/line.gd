class_name Line extends Node2D

@export var point_1 : Vector2
@export var point_2 : Vector2
@export var color : Color
@export var display_width : float = 2

func _draw() -> void:
	draw_line(point_1+position,point_2+position,color,display_width,true)

# return the slope of the line, or INF if it is vertical
func get_slope() -> float:
	if is_equal_approx(point_1.x,point_2.x):
		return INF
	return (point_2.y-point_1.y)/(point_2.x-point_1.x)

# return true if the lines have identical start and end points
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

# return true if the lines have identical slope and y intercept
func is_congruent(line : Line) -> bool:
	if not is_parallel(line):
		return false
	
	if is_equal_approx(point_1.x,point_2.x):
		if is_equal_approx(point_1.x,line.point_1.x):
			return true
		else:
			return false
	
	if is_equal_approx(point_1.y - get_slope() * point_1.x, \
		line.point_1.y - line.get_slope() * line.point_1.x):
		return true
	else:
		return false

# return if the lines have identical slope
func is_parallel(line : Line) -> bool:
	return is_equal_approx(get_slope(),line.get_slope())

# return the position of intersections between this line and another
func get_line_intersection(line) -> Array[Vector2]:
	var out : Array[Vector2] = []
	if is_parallel(line):
		return out
	var t = ((point_1.x-line.point_1.x)*(line.point_1.y-line.point_2.y)-(point_1.y-line.point_1.y)*(line.point_1.x-line.point_2.x))/ \
		((point_1.x - point_2.x)*(line.point_1.y-line.point_2.y)-(point_1.y-point_2.y)*(line.point_1.x-line.point_2.x))
	var x = point_1.x + t*(point_2.x-point_1.x)
	var y = point_1.y + t*(point_2.y-point_1.y)
	out.append(Vector2(x,y))
	return out
