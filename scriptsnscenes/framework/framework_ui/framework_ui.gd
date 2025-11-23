class_name FrameworkUI
extends CanvasLayer

const BOOT_HEIGHT_OFFSET : float = -1000
@export var logo : TextureRect
@export var title : RichTextLabel
@export_group("Boot")
@export var boot : Control
@export var buttons : VBoxContainer
@export var but_again : Button
@export var but_move_on : Button
@export var but_quit : Button
@export_group("Menu")
@export var menu : Menu

func _ready() -> void:
	Global.boot_laptop.connect(anim_start)
	logo.pivot_offset = logo.size/2.
	title.hide()
	logo.show()
	buttons.hide()
	boot.show()
	but_again.pressed.connect(_on_again)
	but_move_on.pressed.connect(_on_move_on)
	but_quit.pressed.connect(_on_quit)

func anim_start():
	var t : = create_tween()
	t.set_trans(Tween.TRANS_CUBIC).set_parallel(true)
	logo.rotation = 0
	t.tween_property(logo, "rotation", 2*PI, .6)
	t.chain()
	t.tween_callback(anim_2)

func anim_2():
	var t : = create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_parallel(true)
	title.position.y = -BOOT_HEIGHT_OFFSET
	title.show()
	t.tween_property(logo, "position:y", BOOT_HEIGHT_OFFSET, .7)
	t.tween_property(title, "position:y", 0, .7)
	t.chain()
	t.tween_callback(anim_3)

func anim_3():
	var t : = create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_parallel(true)
	var og = buttons.position.y
	buttons.position.y += 400
	buttons.show()
	t.tween_property(buttons, "position:y", og, 0.5)

func anim_out():
	var t : = create_tween()
	t.set_trans(Tween.TRANS_BACK)
	t.set_parallel(true)
	t.tween_property(boot, "modulate:a", 0, .4)
	await t.finished
	return

func _on_again() -> void:
	get_tree().reload_current_scene()

func _on_move_on() -> void:
	await anim_out()
	menu.anim_in()

func _on_quit() -> void:
	get_tree().quit()
