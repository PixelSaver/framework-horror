extends Control
class_name Menu

const CAM_RIGHT_POS: Vector3 = Vector3(2.953, 0.709, 1.58253)
const CAM_RIGHT_ROT: Vector3 = Vector3(-8, 65.2, 0)
const CAM_RETURN_POS: Vector3 = Vector3(0, 2.10325, 1.98516)
const CAM_RETURN_ROT: Vector3 = Vector3(-29.4, 0, 0)

var tweening : int = -2
var t : Tween
var disabled := true

func _ready():
	self.hide()

func _input(_event: InputEvent) -> void:
	if not visible or disabled: return
	
	if Input.is_action_pressed("a"):
		tween_cam(-1)
	elif Input.is_action_pressed("d"):
		tween_cam(1)
	else:
		tween_cam(0)

## Tweening, 1 means right, 0 means back, and -1 means left
func tween_cam(modifier:int):
	if tweening == modifier: return # -1, 0, and 1 are only valid modifiers
	match modifier:
		-1:
			Global.framework_13.anim_left()
			Global.framework_13.anim_right(true)
		1:
			Global.framework_13.anim_right()
			Global.framework_13.anim_left(true)
	tweening = modifier
	var target_pos = Vector3(CAM_RIGHT_POS.x*modifier, CAM_RIGHT_POS.y, CAM_RIGHT_POS.z)
	var target_rot = Vector3(CAM_RIGHT_ROT.x, CAM_RIGHT_ROT.y*modifier, CAM_RIGHT_ROT.z)
	if tweening == 0:
		target_pos = CAM_RETURN_POS
		target_rot = CAM_RETURN_ROT
	if t: t.kill()
	t = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	t.tween_property(Global.main.cam, "position", target_pos, .7)
	t.tween_property(Global.main.cam, "rotation_degrees", target_rot, .7)
	t.tween_callback(func(): tweening = -2)

func anim_in():
	self.show()
	disabled = false
