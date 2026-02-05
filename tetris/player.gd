extends Node3D

@export var queue_length : int = 5;
@export var Pieces : Array[PackedScene] = []
@export var max_resets: int = 5
var reset_count:int = 0

var current_piece_scene: PackedScene = null
var current_piece: Piece = null
var used_hold: bool = false
var hold_piece: PackedScene = null
var queue_pieces : Array[PackedScene] = []
var tick_speed_sec :float= 0.4
var lines_cleared :int =  0


signal game_over
signal update_queue(pieces)
# pass packedScene instead? not operating on used opbject, just "type"
# mybe pass type? load("res://path/to/my_node_scene.tscn")
signal hold(piece)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	Globals.shape_locked.connect(_on_locked)
	Globals.line_cleared.connect(line_cleared)
	$Timer.start(tick_speed_sec)
	
	for i in range(queue_length):
		queue_pieces.push_back(Pieces.pick_random())
	update_queue.emit(queue_pieces)
	call_deferred("_on_locked")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if !current_piece:
		return
		
	if Input.is_action_just_pressed("move_right"):
		current_piece.move(Vector3.RIGHT)
		current_piece.projection()
	if Input.is_action_just_pressed("move_left"):
		current_piece.move(Vector3.LEFT)
		current_piece.projection()
	if Input.is_action_just_pressed("rotate_right"):
		current_piece.rotate_clockwise()
		current_piece.projection()
	if Input.is_action_just_pressed("rotate_left"):
		current_piece.rotate_anticlockwise()
		current_piece.projection()
	if Input.is_action_just_pressed("hold") && !used_hold:
		#used_hold = true
		# todo this ugly af and has bug fs
		current_piece.queue_free()
		if hold_piece:
			var temp = current_piece_scene
			current_piece_scene = hold_piece
			hold_piece = temp
			current_piece = current_piece_scene.instantiate()
		else:
			hold_piece = current_piece_scene 
			current_piece_scene = next_block()
			current_piece = current_piece_scene.instantiate()
		hold.emit(hold_piece)
		add_child(current_piece)
		current_piece.projection()
	if Input.is_action_just_pressed("move_down"):
		fall()
		$Timer.start(0.05)
	if Input.is_action_just_released("move_down"):
		$Timer.start(tick_speed_sec)
	if Input.is_action_just_pressed("hard_drop"):
		current_piece.fall_max()
		current_piece.lock()
	if Input.is_action_just_pressed("pause"):
		# todo display UI
		if !$Timer.is_stopped():
			$Timer.stop()
		else:
			$Timer.start(tick_speed_sec)

func next_block() -> PackedScene:
	var next = queue_pieces.pop_front()
	queue_pieces.push_back(Pieces.pick_random())
	update_queue.emit(queue_pieces)
	return next

func fall() -> void:
	if !current_piece.move(Vector3.DOWN):
		current_piece.lock()
		used_hold = false
		reset_count = 0
	# todo test if next fall is lock and play animation fadeout+call lock

func _on_locked() -> void:
	if can_spawn():
		current_piece_scene = next_block()
		current_piece = current_piece_scene.instantiate()
		add_child(current_piece)
		current_piece.projection()
		print(current_piece)
	else:
		$Timer.stop()
		game_over.emit()

func can_spawn() -> bool:
	$RayCast3D.force_raycast_update()
	var res = $RayCast3D.get_collider();
	print("game over:", res)
	return res == null
	
func line_cleared(count):
	lines_cleared += count
	print(lines_cleared)
	if lines_cleared %20 ==0:
		tick_speed_sec -= tick_speed_sec*0.1
		print("speed ", tick_speed_sec)
		$Timer.start(tick_speed_sec)
	update_score()
	
func update_score():
	Globals.update_score.emit(lines_cleared)
