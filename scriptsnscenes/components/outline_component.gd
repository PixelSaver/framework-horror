extends Node
class_name OutlineComponent

@export var outline_shader_mat : ShaderMaterial
@export var meshes : Array[MeshInstance3D]

func _ready() -> void:
	if meshes.size() == 0: meshes = [get_parent()]
	Global.update_outlines.connect(_on_update)

func is_outlined() -> bool:
	return meshes[0].material_overlay != null

func _on_update():
	if Global.current_outline == self:
		outline_parent(true)
	else: outline_parent(false)

func outline_parent(do:bool):
	for mesh in meshes:
		if do:
			mesh.material_overlay = outline_shader_mat
		else:
			mesh.material_overlay = null
