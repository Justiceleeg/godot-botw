extends MeshInstance3D

func _ready() -> void:
	print(mesh.surface_get_material(0))

func _physics_process(delta: float) -> void:
	rotation_degrees += Vector3(0,delta*10,0)
	position += Vector3(delta,0,0)
