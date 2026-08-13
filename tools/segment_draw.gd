class_name SegmentDrawTool extends Tool

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
		var created_arr := main.create_line(selected_point.position,point.position)
		main.undo_stack.do_construction(created_arr)
		on_deselect()

func on_deselect() -> void:
	if point_selected:selected_point.deselect()
	point_selected = false
