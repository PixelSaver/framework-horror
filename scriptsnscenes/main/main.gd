extends Node3D
class_name Main

const CAM_CLOSE := Vector3(0, 2.457, 0.555)
const CAM_MID := Vector3(0, 3, 1.04)
const CAM_FAR := Vector3(0, 4, 3.06)
@export var cam : Camera3D

func _ready() -> void:
	Global.hinge_anim.connect(_on_hinge_anim)
	cam.position = CAM_FAR

func _process(_delta: float) -> void:
	pass

func _on_hinge_anim(duration:float):
	print("HINGE")
	var t : = create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	t.tween_property(cam, "position", CAM_MID, duration)
	t.chain()
	t.tween_property(cam, "position", CAM_CLOSE, duration)


func _intersect_quad_plane(ray_origin: Vector3, ray_direction: Vector3) -> Dictionary:
	var quad := Global.framework_16.screen_quad as MeshInstance3D
	var mesh := quad.mesh as PlaneMesh
	
	# Get the quad's plane in world space
	var quad_normal = quad.global_transform.basis.y  # PlaneMesh faces along +Y
	var quad_center = quad.global_position
	print("quad center: %s" % quad_center)
	
	# Check if ray is parallel to plane
	var denom = quad_normal.dot(ray_direction)
	if abs(denom) < 0.0001:
		return {}
	
	# Calculate intersection point
	var t = (quad_center - ray_origin).dot(quad_normal) / denom
	if t < 0:
		return {}  # Intersection behind camera
	
	var hit_pos = ray_origin + ray_direction * t
	
	# Convert to plane-local coordinates
	var local_pos = quad.global_transform.affine_inverse() * hit_pos
	
	# Get coordinates along the plane (X and Z in local space)
	var plane_x = local_pos.x
	var plane_z = local_pos.z
	
	# Convert to UV (0-1 range)
	var uv = Vector2(
		(plane_x / mesh.size.x) + 0.5,
		(plane_z / mesh.size.y) + 0.5
	)
	
	print(hit_pos)
	print(uv)
	# Return empty dict if outside bounds
	if uv.x < 0 or uv.x > 1 or uv.y < 0 or uv.y > 1:
		return {}
	# Return hit data
	return {
		"position": hit_pos,
		"uv": uv,
		"plane_coords": Vector2(plane_x, plane_z)
	}

func _send_to_subviewport(event: InputEvent, vp_pos: Vector2):
	var ev = event.duplicate()
	if ev is InputEventMouse:
		ev.position = vp_pos
	
	Global.framework_16.framework_viewport.push_input(ev)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var from = cam.project_ray_origin(event.position)
		var direction = cam.project_ray_normal(event.position)
		
		var result = _intersect_quad_plane(from, direction)
		
		if not result.is_empty():
			print("go")
			var vp_pos = result.uv * Vector2(Global.framework_16.framework_viewport.size)
			_send_to_subviewport(event, vp_pos)

	
