class_name Line extends Node2D

@export var point_1 : Vector2
@export var point_2 : Vector2
@export var color : Color
@export var display_width : float = 3

var reference : bool = false

func _draw() -> void:
	if reference:
		display_width = 1
	
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
func get_line_intersections(line : Line) -> Array[Vector2]:
	var out : Array[Vector2] = []
	if is_parallel(line):
		return out
	var t = ((point_1.x-line.point_1.x)*(line.point_1.y-line.point_2.y)-(point_1.y-line.point_1.y)*(line.point_1.x-line.point_2.x))/ \
		((point_1.x - point_2.x)*(line.point_1.y-line.point_2.y)-(point_1.y-point_2.y)*(line.point_1.x-line.point_2.x))
	var x = point_1.x + t*(point_2.x-point_1.x)
	var y = point_1.y + t*(point_2.y-point_1.y)
	# require the point to be on the segments themselves
	if (is_equal_approx(x,point_1.x) or is_equal_approx(x,point_2.x) or (point_1.x < x and x < point_2.x) or (point_2.x < x and x < point_1.x)) and \
		(is_equal_approx(x,line.point_1.x) or is_equal_approx(x,line.point_2.x) or (line.point_1.x < x and x < line.point_2.x) or (line.point_2.x < x and x < line.point_1.x)):
		out.append(Vector2(x,y))
	return out

# return the position of intersections between this line and an arc
func get_arc_intersections(arc : Arc) -> Array[Vector2]:
	var out : Array[Vector2] = []
	var dx = point_2.x - point_1.x
	var dy = point_2.y - point_1.y
	var dr = sqrt(dx*dx+dy*dy)
	var D = (point_1.x-arc.position.x)*(point_2.y-arc.position.y) - (point_2.x-arc.position.x)*(point_1.y-arc.position.y)
	
	var discriminant = arc.radius*arc.radius*dr*dr-D*D
	if discriminant < 0 and not is_zero_approx(discriminant):
		return out
	
	var s = -1
	if dy > 0 or is_zero_approx(dy):
		s = 1
	
	var x = (D*dy+s*dx *sqrt(arc.radius*arc.radius*dr*dr-D*D))/(dr*dr)
	var y = (-D*dx+abs(dy)*sqrt(arc.radius*arc.radius*dr*dr-D*D))/(dr*dr)
	var out_1 = Vector2(x,y) + arc.position
	var theta = fposmod(atan2(y,x),2*PI)
	if (is_equal_approx(x+arc.position.x,point_1.x) or is_equal_approx(x+arc.position.x,point_2.x) or (point_1.x < x+arc.position.x and x+arc.position.x < point_2.x) or (point_2.x < x+arc.position.x and x+arc.position.x < point_1.x)) and \
		(is_equal_approx(arc.start_angle,theta) or arc.start_angle < theta) and (is_equal_approx(theta,arc.end_angle) or theta < arc.end_angle):
		out.append(out_1)
		print(out_1)
	
	x = (D*dy-s*dx *sqrt(arc.radius*arc.radius*dr*dr-D*D))/(dr*dr)
	y = (-D*dx-abs(dy)*sqrt(arc.radius*arc.radius*dr*dr-D*D))/(dr*dr)
	theta = fposmod(atan2(y,x), 2*PI)
	if (is_equal_approx(out_1.x,x+arc.position.x) and is_equal_approx(out_1.y,y+arc.position.y)):
		return out
	if (is_equal_approx(x+arc.position.x,point_1.x) or is_equal_approx(x+arc.position.x,point_2.x) or (point_1.x < x+arc.position.x and x+arc.position.x < point_2.x) or (point_2.x < x+arc.position.x and x+arc.position.x < point_1.x)) and \
		(is_equal_approx(arc.start_angle,theta) or arc.start_angle < theta) and (is_equal_approx(theta,arc.end_angle) or theta < arc.end_angle):
		out.append(Vector2(x,y)+arc.position)
		print(Vector2(x,y))
	
	return out
