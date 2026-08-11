class_name LineDrawTool extends Tool

var point_selected : bool = false
var selected_point : Point

func on_point_clicked (point : Point) -> void:
	if !point_selected:
		selected_point = point
		point_selected = true
	else:
		var avg_pos : Vector2 = (selected_point.position+point.position)/2
		var l = selected_point.position.distance_to(point.position)
		# The line extends 10,000pixels to either end of its center
		var far_1 : Vector2 = (selected_point.position-avg_pos)/l * 100000
		var far_2 : Vector2 = (point.position-avg_pos)/l * 100000
		main.create_line(far_1+avg_pos,far_2+avg_pos)
		point_selected = false

func on_deselect() -> void:
	point_selected = false
