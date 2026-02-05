extends Node3D
class_name Piece

@export var color: Color = Color(0,0,255)
var state := 0
const WALL_PUSH = [Vector3.ZERO, Vector3.LEFT, Vector3.RIGHT, Vector3.UP, Vector3.DOWN]

func get_rotations() -> Array[Array]:
	return [
		[ Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO ],
		[ Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO ],
		[ Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO ],
		[ Vector3.ZERO, Vector3.ZERO, Vector3.ZERO, Vector3.ZERO ]
	]

func get_blocks() -> Array[Block]:
	var result: Array[Block] = []
	for child in get_children():
		if child is Block:
			result.append(child)
	return result

func set_color() -> void:
	for block in get_blocks():
		block.set_color(color)

func rotate_clockwise() -> void:
	var next = (state+1)%4
	for push in WALL_PUSH:
		if _move({
		$Block: get_rotations()[next][0] - get_rotations()[state][0] + push, 
		$Block2: get_rotations()[next][1] - get_rotations()[state][1] + push,
		$Block3: get_rotations()[next][2] - get_rotations()[state][2] + push,
		$Block4: get_rotations()[next][3] - get_rotations()[state][3] + push}):
			state = next

func rotate_anticlockwise() -> void:
	var next = (state+3)%4
	for push in WALL_PUSH:
		if _move({
		$Block: get_rotations()[next][0] - get_rotations()[state][0] + push, 
		$Block2: get_rotations()[next][1] - get_rotations()[state][1] + push,
		$Block3: get_rotations()[next][2] - get_rotations()[state][2] + push,
		$Block4: get_rotations()[next][3] - get_rotations()[state][3] + push}):
			state = next
	
func lock() -> void:
	if PROJECTION:
		PROJECTION.free()

	for block in get_blocks():
		block.reparent(get_parent())
		block.lock()
	Globals.shape_locked.emit()
	queue_free()

func move(direction: Vector3) -> bool:
	assert(false)
	return true
	
func _move(movment: Dictionary[Block, Vector3]) -> bool:
	# test
	var test = true
	for block in movment:
		if block.move(movment[block], true):
			test = false
			break
	
	if !test:
		return false
	
	# move
	for block in movment:
		block.move(movment[block])
		
	return true


func fall_max():
	for i in range(20):
		if !move(Vector3.DOWN):
			break

var PROJECTION  = null
func projection():
	if PROJECTION:
		PROJECTION.free()
	PROJECTION = self.duplicate() as Piece
	add_child(PROJECTION)
	
	var projection_color = Color() #color
	projection_color.a = 0.50
	PROJECTION.color = projection_color
	PROJECTION.set_color()
	for block in PROJECTION.get_blocks():
		block.set_collision_layer_value(2, false)
		block.set_collision_layer_value(5, true)
	PROJECTION.fall_max()
