class_name Framework16
extends Node3D
## Class to hold the framework 3d, and also animate it

const HINGE_START : float = -PI
const HINGE_END : float =  -PI/3.
@export var hinge : Node3D
@export var framework_viewport : SubViewport
@export var framework_ui : FrameworkUI
@export var screen_quad : MeshInstance3D
var hinge_t : Tween

func _ready() -> void:
	Global.framework_16 = self
	anim_hinge(1)

## Animate the hinge, using -1 or 1 for direction
func anim_hinge(dir:float) -> void:
	var dur = 1.
	Global.hinge_anim.emit(dur)
	var local_hinge_end : float
	if dir != -1 and dir != 1: return
	elif dir == 1: 
		hinge.rotation.x = HINGE_START
		local_hinge_end = HINGE_END
	else: 
		hinge.rotation.x = HINGE_END
		local_hinge_end = HINGE_START
	hinge_t = create_tween()
	hinge_t.set_trans(Tween.TRANS_QUINT)
	hinge_t.tween_property(hinge, "rotation:x", local_hinge_end, dur)
	hinge_t.tween_callback(func():
		Global.boot_laptop.emit()
	)
