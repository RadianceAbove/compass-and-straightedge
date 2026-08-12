class_name ExportScribe extends Node2D

var drawn_lines : Array[Line]
var drawn_arcs : Array[Arc]
var frame : bool = false

func _draw() -> void:
	for arc in drawn_arcs:
		var width = arc.display_width
		var aliasing = true
		if frame:
			width = 1
			aliasing = false
		draw_arc(arc.position, arc.radius, arc.start_angle, arc.end_angle, arc.segments, arc.color, width, aliasing)
	for line in drawn_lines:
		var width = line.display_width
		var aliasing = true
		if frame:
			width = 1
			aliasing = false
		draw_line(line.point_1+line.position,line.point_2+line.position,line.color,width,aliasing)
