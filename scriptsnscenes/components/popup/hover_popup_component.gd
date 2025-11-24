extends Node
class_name HoverPopupComponent

@onready var control: Control = $Control
@onready var panel: Panel = control.get_node(^"Panel")
@onready var line2d: Line2D = control.get_node(^"Line2D")
@onready var title_label: RichTextLabel = control.get_node(^"Panel/VBoxContainer/Title")
@onready var desc_label: RichTextLabel = control.get_node(^"Panel/VBoxContainer/Desc")

@export var title:String
@export var desc:String
@export var left:bool = true

var anchors_lr : Vector2
var par : Node3D
var mark : Marker3D
var popped_up : bool = false
var local : Vector2

func _ready() -> void:
	par = get_parent() as Node3D
	for child in par.get_children():
		if child is Marker3D:
			mark = child
			break
	if not par or not mark: queue_free()
	control.pivot_offset = control.size/2.
	anchors_lr = Vector2(panel.anchor_left, panel.anchor_right)
	title_label.text = title
	desc_label.text = desc

func _process(_delta: float) -> void:
	if _get_outline_comp().is_outlined():
		popup(true, left)
	else:
		popup(false, left)
	
func _update_line():
	
	line2d.clear_points()
	var _size = get_viewport().get_visible_rect().size
	line2d.add_point(_size/2. + Vector2(0, 20))
	var bottom_left = panel.position + panel.get_rect().size * Vector2(0, 1)
	var bottom_right = panel.position + panel.get_rect().size
	if left:
		line2d.add_point(bottom_right)
		line2d.add_point(bottom_left)
	else:
		line2d.add_point(bottom_left)
		line2d.add_point(bottom_right)
	
func popup(do:bool=true, flip_to_left_side:bool=false):
	_update_line()
	var anc = anchors_lr if not flip_to_left_side else Vector2(1-anchors_lr.y, 1-anchors_lr.x)
	panel.anchor_left = anc.x
	panel.anchor_right = anc.y
	if do: 
		popped_up = true
		local = Global.main.cam.unproject_position(mark.global_position)*Global.viewport_mini_scale
		control.position = local - control.pivot_offset
		control.show()
	else: 
		popped_up = false
		control.hide()

func _get_outline_comp() -> OutlineComponent:
	for child in get_parent().get_children():
		if child is OutlineComponent:
			return child
	return
