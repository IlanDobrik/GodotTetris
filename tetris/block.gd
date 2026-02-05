extends RigidBody3D
class_name Block

@export var fall: bool = true

var timer_resets : int = 0

@onready var collision := $CollisionShape3D
@onready var anim := $AnimationPlayer
@onready var mesh := $MeshInstance3D

func set_color(color: Color) -> void:
	# Get the material currently being used by the mesh
	var base_material = mesh.get_active_material(0)

	if base_material:
		var unique_material = base_material.duplicate()
		unique_material.albedo_color = color
		mesh.set_surface_override_material(0, unique_material)

func move(direction: Vector3, test: bool = false) -> KinematicCollision3D:
	var res = move_and_collide(direction, test, 0)
	return res
	
func move_force(direction: Vector3):
	position += direction

func is_locked() -> bool:
	return get_collision_layer_value(4)

func lock() -> void:
	set_collision_layer_value(4, true)
	
func clear():
	collision.disabled = true
	anim.play("FadeOut")
	return anim.animation_finished
