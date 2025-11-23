extends Node3D
class_name Main

const MARGIN := 0.3
@export var cam : Camera3D
@export var anim_player : AnimationPlayer

func _ready() -> void:
	Global.hinge_anim.connect(_on_hinge_anim)
	Global.main = self
	anim_player.play("cam_pos", -1, 0.)
	anim_player.advance(0)
	anim_player.play("slide_in")
	anim_player.animation_finished.connect(func(_name:StringName):
		if _name == "slide_in":
			Global.framework_13.anim_hinge(1)
		)
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
		var from = cam.project_ray_origin(event.position/6)
		var to = from + cam.project_ray_normal(event.position/6) * 1000.0
		
		var query = PhysicsRayQueryParameters3D.create(from, to)
		#query.collide_with_areas = true
		query.collide_with_bodies = true
		
		var result = get_world_3d().direct_space_state.intersect_ray(query)
		
		if result and result.collider.is_in_group("screen"):
			_send_to_subviewport(event, result.position)
		elif result and result.collider.is_in_group("expansion_card"):
			for child in result.get_children():
				if child is not MeshInstance3D: continue
				Global.outline_mesh(child)
	else:
		Global.framework_13.framework_viewport.push_input(event)
	
