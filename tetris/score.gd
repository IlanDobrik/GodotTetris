extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.update_score.connect(update_score)
	text = "Score: 0"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func update_score(score: int):
	text = "Score: " + str(score)
