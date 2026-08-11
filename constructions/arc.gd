class_name Arc extends Node2D

@export var radius : float = 10
@export var start_angle : float = 0
@export var end_angle : float = 2*PI
@export var display_width : float = 2
@export var color : Color
@export var segments : int = 100

func _draw() -> void:
	draw_arc(Vector2.ZERO, radius, start_angle, end_angle, segments, color, display_width, true)
