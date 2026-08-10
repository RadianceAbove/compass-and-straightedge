class_name line extends Node2D

@export var point_1 : Vector2
@export var point_2 : Vector2
@export var color : Color
@export var display_width : float = 2

func _draw() -> void:
	draw_line(point_1+position,point_2+position,color,display_width,true)
