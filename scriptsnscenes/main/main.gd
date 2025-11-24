extends Node3D
class_name Main

const MARGIN := 0.3
@export var cam : Camera3D
@export var anim_player : AnimationPlayer
@export var cam_viewport : SubViewport
const CAM_RETURN_POS: Vector3 = Vector3(0, 2.10325, 1.98516)
const CAM_RETURN_ROT: Vector3 = Vector3(-29.4, 0, 0)
const CAM_EXPLODE_POS: Vector3 = Vector3(0, 2.28046, 4.0453)
const CAM_EXPLODE_ROT: Vector3 = Vector3(-24.9, 0, 0)

func _ready() -> void:
	Global.hinge_anim.connect(_on_hinge_anim)
	Global.main = self
	
	cam_viewport.size = get_viewport().get_visible_rect().size / Global.viewport_mini_scale
	
	anim_player.play("cam_pos", -1, 0.)
	anim_player.advance(0)
	anim_player.play("slide_in")
	anim_player.animation_finished.connect(func(_name:StringName):
		if _name == "slide_in":
			Global.framework_13.anim_hinge(1)
		)
	Global.explode_laptop.connect(_on_explode_laptop)
func _process(_delta: float) -> void:
	pass
func _on_hinge_anim(_duration:float):
	anim_player.play("cam_pos")

func _send_to_subviewport(event: InputEvent, hit_pos: Vector3):
	var quad := Global.framework_13.screen_quad as MeshInstance3D
	var mesh := quad.mesh as PlaneMesh
	var local = quad.to_local(hit_pos)
	
	# UV coordinates (0-1 range)
	var uv = Vector2(
		(local.x / mesh.size.x) + 0.5,
		(local.z / mesh.size.y) + 0.5
	)
	
	if uv.x < 0-MARGIN or uv.x > 1+MARGIN or uv.y < 0-MARGIN or uv.y > 1+MARGIN:
		return
	
	var vp_pos = uv * Vector2(Global.framework_13.framework_viewport.size)
	
	var ev = event.duplicate()
	if ev is InputEventMouse:
		ev.position = vp_pos
	Global.framework_13.framework_viewport.push_input(ev, true)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var scaled_pos = event.position / Global.viewport_mini_scale
		var from = cam.project_ray_origin(scaled_pos)
		var to = from + cam.project_ray_normal(scaled_pos) * 1000.0
		
		var query = PhysicsRayQueryParameters3D.create(from, to)
		#query.collide_with_areas = true
		query.collide_with_bodies = true
		
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		
		if result and result.collider.is_in_group("screen"):
			_send_to_subviewport(event, result.position)
		if result and result.collider.is_in_group("expansion_card"):
			Global.update_outlines.emit()
			for child in result.collider.get_children():
				if child is MeshInstance3D:
					Global.current_outline = child.get_node("OutlineComponent")
		else: Global.current_outline = null
		Global.update_outlines.emit()
	else:
		Global.framework_13.framework_viewport.push_input(event)
	
func _on_explode_laptop(duration:float, direction:int=1):
	var t = create_tween().set_ease(Tween.EASE_OUT)
	var target_pos = CAM_RETURN_POS if direction == -1 else CAM_EXPLODE_POS
	var target_rot = CAM_RETURN_ROT if direction == -1 else CAM_EXPLODE_ROT
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(cam, "global_position", target_pos, duration)
	t.tween_property(cam, "rotation_degrees", target_rot, duration)
