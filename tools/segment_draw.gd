class_name SegmentDrawTool extends Tool

var point_selected : bool = false
var selected_point : Point

func on_point_clicked (point : Point) -> void:
	if !point_selected:
		selected_point = point
		point_selected = true
	else:
		var created_arr := main.create_line(selected_point.position,point.position)
		main.undo_stack.do_construction(created_arr)
		point_selected = false

func on_deselect() -> void:
	point_selected = false
