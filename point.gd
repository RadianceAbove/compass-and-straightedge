class_name Point extends Node2D

@export var coords : Vector2
@export var color : Color
@export var display_radius : float = 5

func _draw() -> void:
	draw_circle(position + coords, display_radius, color, true, -1, true)
