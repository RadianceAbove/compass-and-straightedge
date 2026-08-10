class_name Point extends Node2D

@export var coords : Vector2
@export var color : Color
@export var display_radius : float = 5
signal clicked

func _on_area_clicked(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		clicked.emit()

func _ready() -> void:
	var pickable_area : Area2D = get_child(0)
	pickable_area.get_child(0).shape.radius = display_radius * 2
	pickable_area.input_event.connect(_on_area_clicked)
	

func _draw() -> void:
	draw_circle(position + coords, display_radius, color, true, -1, true)
