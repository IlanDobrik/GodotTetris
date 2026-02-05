extends Node3D

# todo kinda dup of Q


var loaded_piece : Piece = null

func _on_player_hold(piece: PackedScene) -> void:
	var piece_scale = Vector3(0.5, 0.5, 0.5)

	free_loaded_piece()
	
	var dup = piece.instantiate()
	add_child(dup)
	
	dup.scale = piece_scale
	
	loaded_piece = dup

func free_loaded_piece():
	if loaded_piece:
		loaded_piece.queue_free()

func _on_player_game_over() -> void:
	free_loaded_piece()
