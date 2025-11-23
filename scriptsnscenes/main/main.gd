extends Node3D
class_name Main

const CAM_CLOSE := Vector3(0, 2.457, 0.555)
const CAM_MID := Vector3(0, 3, 1.04)
const CAM_FAR := Vector3(0, 4, 3.06)
const MARGIN := 0.3
@export var cam : Camera3D
@export var anim_player : AnimationPlayer

func _ready() -> void:
	Global.hinge_anim.connect(_on_hinge_anim)
	cam.position = CAM_FAR
	anim_player.play("slide_in")
	anim_player.animation_finished.connect(func(_name:StringName):
		Global.framework_16.anim_hinge(1)
		)
func _process(_delta: float) -> void:
	pass
func _on_hinge_anim(duration:float):
	var t : = create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	t.tween_property(cam, "position", CAM_MID, duration)
	t.chain()
	t.tween_property(cam, "position", CAM_CLOSE, duration)

func _send_to_subviewport(event: InputEvent, hit_pos: Vector3):
	var quad := Global.framework_16.screen_quad as MeshInstance3D
	var mesh := quad.mesh as PlaneMesh
	var local = quad.to_local(hit_pos)
	
	# UV coordinates (0-1 range)
	var uv = Vector2(
		(local.x / mesh.size.x) + 0.5,
		(local.z / mesh.size.y) + 0.5
	)
	
	if uv.x < 0-MARGIN or uv.x > 1+MARGIN or uv.y < 0-MARGIN or uv.y > 1+MARGIN:
		return
	
	var vp_pos = uv * Vector2(Global.framework_16.framework_viewport.size)
	
	var ev = event.duplicate()
	if ev is InputEventMouse:
		ev.position = vp_pos
	Global.framework_16.framework_viewport.push_input(ev, true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var from = cam.project_ray_origin(event.position*2/9.)
		var to = from + cam.project_ray_normal(event.position*2/9.) * 1000.0
		
		var query = PhysicsRayQueryParameters3D.create(from, to)
		query.collide_with_areas = true
		query.collide_with_bodies = true
		
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		
		if result and result.collider.is_in_group("screen"):
			_send_to_subviewport(event, result.position)
	
