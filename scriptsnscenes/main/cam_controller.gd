extends Node

@export var cam : Camera3D
var dragging : bool = false
var target := Vector3(0, 0, 0)
var sensitivity := 0.01
var distance := 0.

var yaw := 0.0
var pitch := 0.0

func _ready() -> void:
	Global.explode_laptop.connect(
		func(_duration: float, _dir: int):
			if _dir != 1: return
			await get_tree().create_timer(1.).timeout
			if Global.state != Global.States.EXPLODE: return
			var pos = Global.main.cam.position
			var normal = cam.project_ray_normal(get_viewport().get_visible_rect().size/Global.viewport_mini_scale/2.)
			distance = pos.distance_to(target)
			target = pos + normal * distance
			var offset = target - cam.global_position

			# Compute yaw and pitch from the offset direction
			yaw = atan2(offset.x, offset.z)
			pitch = asin(offset.y / distance)

			_update_camera_position()
	)

func _input(event: InputEvent) -> void:
	if Global.state != Global.States.EXPLODE: return
	if distance == 0.: return
	dragging = true if Input.is_action_pressed("r_click") else false
	if not dragging: return
	
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * sensitivity
		pitch = clamp(pitch - event.relative.y * sensitivity, deg_to_rad(-85), deg_to_rad(0))

		_update_camera_position()

func _update_camera_position():
	var direction = Vector3(
		cos(pitch) * sin(yaw),
		sin(pitch),
		cos(pitch) * cos(yaw)
	)

	cam.global_transform.origin = target - direction * distance
	cam.look_at(target)
