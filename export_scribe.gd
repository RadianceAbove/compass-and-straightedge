class_name ExportScribe extends Node2D

var drawn_lines : Array[Line]
var drawn_arcs : Array[Arc]


func _draw() -> void:
	for arc in drawn_arcs:
		draw_arc(arc.position, arc.radius, arc.start_angle, arc.end_angle, arc.segments, arc.color, arc.display_width, true)
	for line in drawn_lines:
		draw_line(line.point_1+line.position,line.point_2+line.position,line.color,line.display_width,true)
