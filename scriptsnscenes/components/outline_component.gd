extends Node
class_name OutlineComponent

@export var outline_shader_mat : ShaderMaterial
@export var mesh : MeshInstance3D

func _ready() -> void:
	mesh = get_parent()
	Global.update_outlines.connect(_on_update)

func is_outlined() -> bool:
	return mesh.material_overlay != null

func _on_update():
	if Global.current_outline == self:
		outline_parent(true)
	else: outline_parent(false)

func outline_parent(do:bool, _mesh:MeshInstance3D=null):
	if _mesh:
		if do:
			print(_mesh)
			_mesh.material_overlay = outline_shader_mat
			print(_mesh.material_overlay)
		else:
			_mesh.material_overlay = null
	else:
		if do:
			mesh.material_overlay = outline_shader_mat
		else:
			mesh.material_overlay = null
