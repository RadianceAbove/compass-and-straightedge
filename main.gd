extends Control

@onready var canvas : Node2D = self.find_child("Canvas")
@onready var point_container : Node2D = self.find_child("Canvas").find_child("Points")
@onready var constructions_container : Node2D = self.find_child("Canvas").find_child("Constructions")
@export var arc_scene : PackedScene
@export var point_scene : PackedScene
@export var line_scene : PackedScene
var arcs : Array[Arc] = []
var points : Array[Point] = []
var lines : Array[Line] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create the starting canvas:
	var rad = 200
	create_arc(Vector2.ZERO, rad, 0, 2*PI)
	
	for i in range(12):
		var theta : float = i*2*PI/12
		var pos = Vector2(cos(theta)*rad,sin(theta)*rad)
		create_point(pos)

func _process(_delta: float) -> void:
	canvas.position = Vector2(get_viewport_rect().end/2)

func _on_point_clicked(_point : Point) -> void:
	pass

func create_arc(center : Vector2, radius : float, start_angle : float, end_angle : float) -> void:
	var arc : Arc = arc_scene.instantiate()
	arc.radius = radius
	arc.center = center
	arc.start_angle = start_angle
	arc.end_angle = end_angle
	constructions_container.add_child(arc)
	arcs.append(arc)

func create_point(pos : Vector2) -> void:
	var p : Point = point_scene.instantiate()
	p.coords = pos
	point_container.add_child(p)
	points.append(p)
	p.clicked.connect(_on_point_clicked.bind(p))

func create_line(p_1 : Vector2, p_2 : Vector2) -> void:
	var line : Line = line_scene.instantiate()
	line.point_1 = p_1
	line.point_2 = p_2
	constructions_container.add_child(line)
	lines.append(line)
