@tool
extends MeshInstance3D

@export var width := 20
@export var height := 10
@export var cell_size := 1.0

const CHECKER_SCENE : PackedScene = preload("res://full_line_checker.tscn")
var checkers : Array[FullLineChecker] = []

func _ready():
	Globals.shape_locked.connect(_on_timer_timeout)
	
	var mesh := ImmediateMesh.new()
	var mat := StandardMaterial3D.new()
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	mat.albedo_color = Color(0.0, 0.0, 0.0, 1.0)

	mesh.surface_begin(Mesh.PRIMITIVE_LINES, mat)

	# vertical lines
	for x in range(width + 1):
		mesh.surface_add_vertex(Vector3(x * cell_size, 0, 0))
		mesh.surface_add_vertex(Vector3(x * cell_size, 0, height * cell_size))
		
		var checker: FullLineChecker = CHECKER_SCENE.instantiate()
		checker.target_position = Vector3(0,0, height)
		checker.position = Vector3(cell_size/2 + x * cell_size, 0, 0)
		checkers.append(checker)
		add_child(checker)

	# horizontal lines
	for z in range(height + 1):
		mesh.surface_add_vertex(Vector3(0, 0, z * cell_size))
		mesh.surface_add_vertex(Vector3(width * cell_size, 0, z * cell_size))

	mesh.surface_end()
	self.mesh = mesh

# todo animation
func _on_timer_timeout() -> void:
	var shifts : int = 0
	for i in range(checkers.size()):
		var blocks = checkers[i].blocks_in_line()
		if blocks.size() == height:
			print("line ",i, " is full") 
			Globals.line_cleared.emit(1)
			shifts += 1
			for block in blocks:
				await block.clear()
				block.queue_free()
		else:
			for block in blocks:
				block.move_force(Vector3.DOWN * shifts)
