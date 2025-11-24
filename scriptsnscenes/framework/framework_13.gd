class_name Framework13
extends Node3D
## Class to hold the framework 3d, and also animate it

const HINGE_START : float = 0
const HINGE_END : float =  -2*PI/3.
@export var hinge : Node3D
@export var framework_viewport : SubViewport
@export var framework_ui : FrameworkUI
@export var screen_quad : MeshInstance3D
@export_group("Explosion Parts")
@export var mobo : Node3D
@export var keeb : Node3D
var mobo_og_y : float
var keeb_og_y : float
var hinge_t : Tween
var exp_t : Tween
var explosion_dir := 0
var t_left : Array
var t_right : Array

func _ready() -> void:
	Global.framework_13 = self
	hinge.rotation.x = HINGE_START
	t_left = get_tree().get_nodes_in_group("tween_left")
	t_right = get_tree().get_nodes_in_group("tween_right")
	Global.explode_laptop.connect(_on_explode_parts)
	mobo_og_y = mobo.global_position.y
	keeb_og_y = keeb.global_position.y

func anim_right(backwards:bool=false):
	for thing in t_right:
		var tweenable : Tweenable = thing.get_node_or_null("Tweenable")
		tweenable.tween(backwards)

func anim_left(backwards:bool=false):
	for thing in t_left:
		var tweenable : Tweenable = thing.get_node_or_null("Tweenable")
		tweenable.tween(backwards)

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

func _on_explode_parts(duration:float, direction:int=1):
	if !(direction == 1 || direction == -1): return
	if explosion_dir == direction: return
	explosion_dir = direction
	
	if exp_t: exp_t.kill()
	
	var mult = 1 if direction == 1 else 0
	
	exp_t = create_tween().set_ease(Tween.EASE_OUT)
	exp_t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	exp_t.tween_property(mobo, "global_position:y", lerpf(mobo_og_y, .5, mult), duration)
	exp_t.tween_property(keeb, "global_position:y", lerpf(keeb_og_y, .7, mult), duration)
	anim_left()
	anim_right()
