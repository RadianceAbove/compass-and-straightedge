class_name Arc extends Node2D

@export var radius : float = 10
@export var start_angle : float = 0
@export var end_angle : float = 2*PI
@export var display_width : float = 2
@export var color : Color
@export var segments : int = 100

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, start_angle, end_angle, segments, color, display_width, true)

# return if two arcs are identical
func is_equal(arc : Arc) -> bool:
	return is_coincident(arc) and \
			is_equal_approx(start_angle,arc.start_angle) and \
			is_equal_approx(end_angle,arc.end_angle)

# return if two arcs have identical center and radius
func is_coincident(arc : Arc) -> bool:
	return is_concentric(arc) and \
			is_equal_approx(radius,arc.radius)

# return if two arcs have identical center
func is_concentric(arc : Arc) -> bool:
	return is_equal_approx(position.x,arc.position.x) and \
			is_equal_approx(position.y,arc.position.y)

# return if this arc contains or is contained by another arc, without any tangent points
func is_contained(arc : Arc) -> bool:
	var dist = position.distance_to(arc.position)
	var diff = abs(radius-arc.radius)
	return not is_equal_approx(diff,dist) and dist < diff

# return if this arc doesn't have any overlap with another arc.
func is_seperate(arc : Arc) -> bool:
	var dist = position.distance_to(arc.position)
	return not is_equal_approx(dist,radius+arc.radius) and dist > radius+arc.radius

# return the position of intersections between this arc and a line
func get_line_intersections(line : Line) -> Array[Vector2]:
	return line.get_arc_intersections(self)

# return the position of intersectionss between this arc and another
func get_arc_intersections(arc : Arc) -> Array[Vector2]:
	# see https://stackoverflow.com/questions/3349125/circle-circle-intersection-points
	var out : Array[Vector2] = []
	
	if is_concentric(arc) or is_contained(arc) or is_seperate(arc):
		return out
	
	var d = position.distance_to(arc.position)
	var a = (radius*radius - arc.radius*arc.radius + d*d)/(2*d)
	var h = sqrt(radius * radius - a*a)
	
	var p2 = position + a*(arc.position-position)/d
	
	var x = p2.x + h*(arc.position.y-position.y)/d
	var y = p2.y - h*(arc.position.x-position.x)/d
	
	# ensure that the point is within the angle of the arc
	var theta_1 = fposmod(atan2(y-position.y,x-position.x),2*PI)
	var theta_2 = fposmod(atan2(y-arc.position.y,x-arc.position.x),2*PI)
	var vec = Vector2(x,y)
	if (is_equal_approx(start_angle,theta_1) or start_angle < theta_1) and (is_equal_approx(theta_1,end_angle) or theta_1 < end_angle) and \
		(is_equal_approx(arc.start_angle,theta_2) or arc.start_angle < theta_2) and (is_equal_approx(theta_2,arc.end_angle) or theta_2 < arc.end_angle):
		out.append(vec)
	
	# do the same for the second intersection point
	x = p2.x - h*(arc.position.y-position.y)/d
	y = p2.y + h*(arc.position.x-position.x)/d
	theta_1 = fposmod(atan2(y-position.y,x-position.x),2*PI)
	theta_2 = fposmod(atan2(y-arc.position.y,x-arc.position.x),2*PI)
	if (is_equal_approx(start_angle,theta_1) or start_angle < theta_1) and (is_equal_approx(theta_1,end_angle) or theta_1 < end_angle) and \
		(is_equal_approx(arc.start_angle,theta_2) or arc.start_angle < theta_2) and (is_equal_approx(theta_2,arc.end_angle) or theta_2 < arc.end_angle) and \
		not (is_equal_approx(x,vec.x) and is_equal_approx(y,vec.y)):
		out.append(Vector2(x,y))
	
	return out
