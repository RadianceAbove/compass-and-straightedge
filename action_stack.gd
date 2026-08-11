class_name ActionStack extends RefCounted

var done_actions : Array[Action] = []
var undone_actions : Array[Action] = []
var main : MainScene

class Action:
	var created_points : Array[Point] = []
	var point_parent : Node
	var created_lines : Array[Line] = []
	var line_parent : Node
	var created_arcs : Array[Arc] = []
	var arc_parent : Node
	var main : MainScene
	
	# destroy objects in action that arent needed anymore
	func clear() -> void:
		for p in created_points:
			p.queue_free()
		for l in created_lines:
			l.queue_free()
		for a in created_arcs:
			a.queue_free()
	
	# remove the objects created by the action from the scene tree
	func isolate() -> void:
		for p in created_points:
			point_parent = p.get_parent()
			point_parent.remove_child(p)
			main.points.erase(p)
		for l in created_lines:
			line_parent = l.get_parent()
			line_parent.remove_child(l)
			main.lines.erase(l)
		for a in created_arcs:
			arc_parent = a.get_parent()
			arc_parent.remove_child(a)
			main.arcs.erase(a)
	
	func attach() -> void:
		for p in created_points:
			point_parent.add_child(p)
			main.points.append(p)
		for l in created_lines:
			line_parent.add_child(l)
			main.lines.append(l)
		for a in created_arcs:
			arc_parent.add_child(a)
			main.arcs.append(a)

func _init(m : MainScene) -> void:
	main = m

# Take in an array of created constructions
func do_construction(construction_array : Array) -> void:
	var points : Array[Point] = []
	var lines : Array[Line] = []
	var arcs : Array[Arc] = []
	
	# Sort constructions by type
	for c in construction_array:
		if c is Point:
			points.append(c)
		if c is Line:
			lines.append(c)
		if c is Arc:
			arcs.append(c)
	
	var action := Action.new()
	action.created_points = points
	action.created_lines = lines
	action.created_arcs = arcs
	action.main = main
	
	#for a in undone_actions:
	#	action.clear()
	undone_actions.clear()
	
	done_actions.append(action)

func undo() -> void:
	var action = done_actions.pop_back()
	if action is Action:
		action.isolate()
		undone_actions.append(action)

func redo() -> void:
	var action = undone_actions.pop_back()
	if action is Action:
		action.attach()
		done_actions.append(action)
	
