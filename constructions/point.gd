class_name Point extends Node2D

@export var color : Color
@export var display_radius : float = 5
@export var selectable_radius : float = 6.5
@export var selected_radius : float = 8
var _selected = false
var _mouse_near = false
var _selectable = false
signal clicked

func _on_area_event(_viewport, event, _shape_idx):
	if event.is_action_pressed("select"):
		clicked.emit()
		queue_redraw()

func _mouse_close():
	_mouse_near = true
	queue_redraw()

func _mouse_far():
	_mouse_near = false
	queue_redraw()

func _make_selectable():
	_selectable = true
	queue_redraw()

func _make_unselectable():
	_selectable = false
	queue_redraw()

func select():
	_selected = true
	queue_redraw()

func deselect():
	_selected = false
	queue_redraw()

func _ready() -> void:
	var pickable_area : Area2D = get_child(0)
	pickable_area.input_event.connect(_on_area_event)
	pickable_area.mouse_entered.connect(_make_selectable)
	pickable_area.mouse_exited.connect(_make_unselectable)
	var visible_area : Area2D = get_child(1)
	visible_area.mouse_entered.connect(_mouse_close)
	visible_area.mouse_exited.connect(_mouse_far)

func _draw() -> void:
	if _selected:
		draw_circle(Vector2(0,0), selected_radius, color, true, -1, true)
	elif _selectable:
		draw_circle(Vector2(0,0), selectable_radius, color, true, -1, true)
	elif _mouse_near:
		draw_circle(Vector2(0,0), display_radius, color, true, -1, true)

func is_equal(point : Point) -> bool:
	if is_equal_approx(point.position.x, position.x) and is_equal_approx(point.position.y,position.y):
		return true
	else:
		return false
