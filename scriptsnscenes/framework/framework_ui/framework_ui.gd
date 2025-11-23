class_name FrameworkUI
extends CanvasLayer

@export var logo : TextureRect

func _ready() -> void:
	Global.boot_laptop.connect(anim_start)

func anim_start():
	var t : = create_tween().set_ease(Tween.EASE_OUT)
	t.set_trans(Tween.TRANS_QUINT).set_parallel(true)
	logo.rotation = 0
	t.tween_property(logo, "rotation", 2*PI, 1.)
