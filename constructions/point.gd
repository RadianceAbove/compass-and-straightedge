class_name Point extends Node2D

@export var color : Color
@export var display_radius : float = 5
signal clicked

func _on_area_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("select"):
		clicked.emit()

func _ready() -> void:
	var pickable_area : Area2D = get_child(0)
	pickable_area.get_child(0).shape.radius = display_radius * 2
	pickable_area.input_event.connect(_on_area_event)
	

func _draw() -> void:
	draw_circle(Vector2(0,0), display_radius, color, true, -1, true)

func is_equal(point : Point) -> bool:
	if is_equal_approx(point.position.x, position.x) and is_equal_approx(point.position.y,position.y):
		return true
	else:
		return false
