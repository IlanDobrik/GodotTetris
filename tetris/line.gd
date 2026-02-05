extends Piece

func _ready() -> void:
	set_color()

func move(direction: Vector3) -> bool:
	return _move({$Block: direction, $Block2: direction,$Block3: direction,$Block4: direction})

func get_rotations():
	return [
	[ Vector3(0,-3, 0), Vector3(0,-2, 0), Vector3(0,-1, 0), Vector3(0,0, 0) ], # UP
	[ Vector3(-1,0, 0), Vector3(0,0, 0), Vector3(1,0, 0), Vector3(2,0, 0) ], # RIGHT
	[ Vector3(0,-3, 0), Vector3(0,-2, 0), Vector3(0,-1, 0), Vector3(0,0, 0) ], # UP
	[ Vector3(-1,0, 0), Vector3(0,0, 0), Vector3(1,0, 0), Vector3(2,0, 0) ], # RIGHT
]
