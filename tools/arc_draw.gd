class_name ArcDrawTool extends Tool

var center_point_selected : bool = false
var center_point : Point
var arc_point_selected : bool = false
var arc_point : Point

func on_point_clicked (point : Point) -> void:
	if !center_point_selected:
		center_point = point
		center_point_selected = true
		center_point.select()
	elif point == center_point:
		on_deselect()
	elif !arc_point_selected:
		arc_point = point
		arc_point_selected = true
		arc_point.select()
	elif arc_point == point:
		on_deselect()
	else:
		var start = atan2(arc_point.position.y-center_point.position.y,arc_point.position.x-center_point.position.x)
		var end = atan2(point.position.y-center_point.position.y,point.position.x-center_point.position.x)
		if is_equal_approx(start,end):
			on_deselect()
			return
		if end<start:
			end += 2*PI
		
		var created_arr := main.create_arc(center_point.position,arc_point.position.distance_to(center_point.position), start, end)
		main.undo_stack.do_construction(created_arr)
		on_deselect()

func on_deselect() -> void:
	if center_point_selected: center_point.deselect()
	if arc_point_selected: arc_point.deselect()
	center_point_selected = false
	arc_point_selected = false
