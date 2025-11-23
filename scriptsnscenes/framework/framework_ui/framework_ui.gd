class_name FrameworkUI
extends CanvasLayer

const BOOT_HEIGHT_OFFSET : float = -1000
@export var logo : TextureRect
@export var title : RichTextLabel
@export var control : Control

func _ready() -> void:
	Global.boot_laptop.connect(anim_start)
	logo.pivot_offset = logo.size/2.
	title.hide()
	logo.show()
	

func anim_start():
	var t : = create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	logo.rotation = 0
	t.tween_property(logo, "rotation", 2*PI, 1.)
	t.chain()
	t.tween_callback(anim_2)

func anim_2():
	var t : = create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_parallel(true)
	title.position.y = -BOOT_HEIGHT_OFFSET
	title.show()
	t.tween_property(logo, "position:y", BOOT_HEIGHT_OFFSET, 1)
	t.tween_property(title, "position:y", 0, 1)
