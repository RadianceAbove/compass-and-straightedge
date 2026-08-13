class_name LineDrawTool extends Tool

var point_selected : bool = false
var selected_point : Point

func on_point_clicked (point : Point) -> void:
	if !point_selected:
		selected_point = point
		point_selected = true
		selected_point.select()
	elif point == selected_point:
		on_deselect() 
	else:
		var avg_pos : Vector2 = (selected_point.position+point.position)/2
		var l = selected_point.position.distance_to(point.position)
		# The line extends 10,000 pixels to either end of its center
		var far_1 : Vector2 = (selected_point.position-avg_pos)/l * 100000
		var far_2 : Vector2 = (point.position-avg_pos)/l * 100000
		var created_arr := main.create_line(far_1+avg_pos,far_2+avg_pos)
		main.undo_stack.do_construction(created_arr)
		on_deselect()

func on_deselect() -> void:
	if point_selected: selected_point.deselect()
	point_selected = false
