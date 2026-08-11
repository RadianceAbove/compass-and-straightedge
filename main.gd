class_name MainScene extends Control

@onready var canvas : Node2D = self.find_child("Canvas")
@onready var point_container : Node2D = self.find_child("Canvas").find_child("Points")
@onready var constructions_container : Node2D = self.find_child("Canvas").find_child("Constructions")
@export var arc_scene : PackedScene
@export var point_scene : PackedScene
@export var line_scene : PackedScene
@export var tool_button_scene : PackedScene
@export var tools : Array[Tool]
var current_tool : Tool = null
var arcs : Array[Arc] = []
var points : Array[Point] = []
var lines : Array[Line] = []


func _ready() -> void:
	# Create the starting canvas:
	var rad = 200
	create_arc(Vector2.ZERO, rad, 0, 2*PI)
	create_arc(Vector2(-200,0), rad, 0, 2*PI)
	
	for i in range(12):
		var theta : float = i*2*PI/12
		var pos = Vector2(cos(theta)*rad,sin(theta)*rad)
		create_point(pos)
	
	# Set the starting tool
	current_tool = tools[0]
	tools[0].main = self

func _process(_delta: float) -> void:
	canvas.position = Vector2(get_viewport_rect().end/2)
	
	if Input.is_action_just_pressed("deselect"):
		current_tool.on_deselect()

func _on_point_clicked(point : Point) -> void:
	current_tool.on_point_clicked(point)

func create_arc(center : Vector2, radius : float, start_angle : float, end_angle : float) -> void:
	var arc : Arc = arc_scene.instantiate()
	arc.radius = radius
	arc.position = center
	arc.start_angle = start_angle
	arc.end_angle = end_angle
	constructions_container.add_child(arc)
	arcs.append(arc)

func create_point(pos : Vector2) -> void:
	var point : Point = point_scene.instantiate()
	point.position = pos
	for p in points:
		if point.is_equal(p):
			return
	point_container.add_child(point)
	points.append(point)
	point.clicked.connect(_on_point_clicked.bind(point))

func create_line(p_1 : Vector2, p_2 : Vector2) -> void:
	var line : Line = line_scene.instantiate()
	line.point_1 = p_1
	line.point_2 = p_2
	
	var intersections : Array[Vector2] = []
	
	for l in lines:
		if l.is_equal(line):
			return
		intersections.append_array(line.get_line_intersection(l))
	
	for a in arcs:
		intersections.append_array(line.get_arc_intersections(a))
	
	for v in intersections:
		create_point(v)
	
	constructions_container.add_child(line)
	lines.append(line)
