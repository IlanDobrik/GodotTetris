extends Piece

func get_rotations() -> Array[Array]:
	return  [
	[ Vector3(0,0, 0), Vector3(-1,0, 0), Vector3(1,0, 0), Vector3(1,-1, 0) ], # UP
	[ Vector3(0,0, 0), Vector3(0,-1, 0), Vector3(0,1, 0), Vector3(-1,-1, 0) ], # LEFT
	[ Vector3(0,0, 0), Vector3(-1,0, 0), Vector3(1,0, 0), Vector3(-1,1, 0) ], # DOWN
	[ Vector3(0,0, 0), Vector3(0,-1, 0), Vector3(0,1, 0), Vector3(1,1, 0) ], # RIGHT
]

func _ready() -> void:
	set_color()

func move(direction: Vector3) -> bool:
	return _move({$Block: direction, $Block2: direction,$Block3: direction,$Block4: direction})
