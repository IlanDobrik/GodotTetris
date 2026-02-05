extends RayCast3D
class_name FullLineChecker

signal full_line(blocks)

func blocks_in_line() -> Array[Block]:
	var hits: Array[Block] = []
	var current_exclude : Array[RID] = []
	
	while true:	
		force_raycast_update()
		var result = get_collider() as Block

		if !result:
			break

		hits.append(result)

		current_exclude.append(result)
		add_exception(result)
	clear_exceptions()
	
	return hits
