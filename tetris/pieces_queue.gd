extends Node3D

var loaded_pieces : Array[Piece] = []

func _on_player_update_queue(pieces: Array[PackedScene]) -> void:
	var spawn_position = Vector3(0, -3, 0)
	var piece_scale = Vector3(0.5, 0.5, 0.5)
	
	free_loaded_pieces()
	
	for i in range(pieces.size()):
		var dup = pieces[i].instantiate()
		
		dup.position = spawn_position*i
		dup.scale = piece_scale
		add_child(dup)
		loaded_pieces.push_back(dup)

func free_loaded_pieces():
	for piece in loaded_pieces:
		piece.queue_free()
	loaded_pieces = []

func _on_player_game_over() -> void:
	free_loaded_pieces()
