class_name MainScene extends Control

@onready var canvas : Node2D = self.find_child("Canvas")
@onready var point_container : Node2D = self.find_child("Canvas").find_child("Points")
@onready var constructions_container : Node2D = self.find_child("Canvas").find_child("Constructions")
@onready var tool_list : VBoxContainer = self.find_child("ToolList")
@export var arc_scene : PackedScene
@export var point_scene : PackedScene
@export var line_scene : PackedScene
@export var tool_button_scene : PackedScene
@export var tools : Array[Tool]
@export var zoom_speed : float = .1
var current_tool : Tool = null
var arcs : Array[Arc] = []
var points : Array[Point] = []
var lines : Array[Line] = []
var panning : bool = false
var pan_offset : Vector2 = Vector2.ZERO

var undo_stack : ActionStack = ActionStack.new(self)
@onready var export_dialog : FileDialog = self.find_child("ExportDialog")
@onready var export_width : LineEdit = self.find_child("MainButtons").find_child("SizeContainer").find_child("Width")
@onready var export_height : LineEdit = self.find_child("MainButtons").find_child("SizeContainer").find_child("Height")
@onready var export_scale : LineEdit = self.find_child("MainButtons").find_child("Scale")

func _ready() -> void:
	# Set up the canvas
	get_tree().root.size_changed.connect(_on_window_resized)
	canvas.position = Vector2(get_viewport_rect().end/2)
	
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
	for tool in tools:
		tool.main = self
		var tool_button : Button = tool_button_scene.instantiate()
		tool_button.text = tool.name
		tool_list.add_child(tool_button)
		tool_button.pressed.connect(_on_tool_selected.bind(tool))
	
	# Set Buttons
	var undo_button : Button = find_child("MainButtons").find_child("Undo")
	undo_button.pressed.connect(undo_stack.undo)
	var redo_button : Button = find_child("MainButtons").find_child("Redo")
	redo_button.pressed.connect(undo_stack.redo)
	var export_button : Button = find_child("MainButtons").find_child("Export")
	export_button.pressed.connect(_on_export_clicked)
	export_dialog.file_selected.connect(_on_export_confirmed)

func _process(_delta: float) -> void:
	# Handle inputs
	if Input.is_action_just_pressed("deselect"):
		current_tool.on_deselect()
	if Input.is_action_just_pressed("zoom_in"):
		canvas.scale *= Vector2(1+zoom_speed,1+zoom_speed)
	if Input.is_action_just_pressed("zoom_out"):
		canvas.scale *= Vector2(1/(1+zoom_speed),1/(1+zoom_speed))
		#canvas.scale.x = max(canvas.scale.x,0)
		#canvas.scale.y = max(canvas.scale.y,0)
	if Input.is_action_just_pressed("pan"):
		pan_offset = canvas.position - get_local_mouse_position()
		panning = true
	if Input.is_action_just_released("pan"):
		panning = false
	if panning:
		canvas.position = get_local_mouse_position() + pan_offset

func _on_window_resized():
	canvas.position = Vector2(get_viewport_rect().end/2)

func _on_point_clicked(point : Point) -> void:
	current_tool.on_point_clicked(point)

func _on_tool_selected(tool : Tool) -> void:
	current_tool.on_deselect()
	current_tool = tool

func _on_export_clicked() -> void:
	if export_width.text.to_int() > 0 and export_height.text.to_int() > 0 and export_scale.text.to_int() > 0:
		export_dialog.visible = true

func _on_export_confirmed(filepath : String) -> void:
	print("saved")
	var width = export_width.text.to_int()
	var height = export_height.text.to_int()
	var out_scale = export_scale.text.to_float()
	var out_offset = Vector2(float(width)/2,float(height)/2)
	var view = SubViewport.new()
	view.size = Vector2(width, height)
	view.render_target_update_mode =SubViewport.UPDATE_DISABLED
	view.transparent_bg = true
	var drawn_arcs : Array[Arc] = []
	var drawn_lines : Array[Line] = []
	for arc in arcs:
		drawn_arcs.append(arc)
	for line in lines:
		drawn_lines.append(line)
	
	var scribe : ExportScribe = ExportScribe.new()
	scribe.drawn_arcs = drawn_arcs
	scribe.drawn_lines = drawn_lines
	scribe.scale = Vector2.ONE * out_scale
	scribe.position = out_offset
	
	view.add_child(scribe)
	add_child(view)
	view.render_target_update_mode = SubViewport.UPDATE_ONCE
	await RenderingServer.frame_post_draw
	view.get_texture().get_image().save_png(filepath)

func create_arc(center : Vector2, radius : float, start_angle : float, end_angle : float) -> Array:
	var arc : Arc = arc_scene.instantiate()
	arc.radius = radius
	arc.position = center
	arc.start_angle = start_angle
	arc.end_angle = end_angle
	
	var intersections : Array[Vector2]
	
	for a in arcs:
		if arc.is_equal(a):
			return []
		intersections.append_array(arc.get_arc_intersections(a))
	
	for l in lines:
		intersections.append_array(arc.get_line_intersections(l))
	
	var out = []
	for v in intersections:
		var p = create_point(v)
		if p is Point:
			out.append(p)
	
	constructions_container.add_child(arc)
	arcs.append(arc)
	out.append(arc)
	return out

func create_point(pos : Vector2) -> Point:
	var point : Point = point_scene.instantiate()
	point.position = pos
	for p in points:
		if point.is_equal(p):
			return 
	point_container.add_child(point)
	points.append(point)
	point.clicked.connect(_on_point_clicked.bind(point))
	return point

func create_line(p_1 : Vector2, p_2 : Vector2) -> Array:
	var line : Line = line_scene.instantiate()
	line.point_1 = p_1
	line.point_2 = p_2
	
	var intersections : Array[Vector2] = []
	
	for l in lines:
		if l.is_equal(line):
			return []
		intersections.append_array(line.get_line_intersections(l))
	
	for a in arcs:
		intersections.append_array(line.get_arc_intersections(a))
	
	var out = []
	for v in intersections:
		var p = create_point(v)
		if p is Point:
			out.append(p)
	
	constructions_container.add_child(line)
	lines.append(line)
	out.append(line)
	return out
