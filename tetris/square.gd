extends Piece

func _ready() -> void:
	set_color()

func move(direction: Vector3) -> bool:
	return _move({$Block: direction, $Block2: direction,$Block3: direction,$Block4: direction})
