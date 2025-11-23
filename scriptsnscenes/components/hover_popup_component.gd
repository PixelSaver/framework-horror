extends Node
class_name HoverPopupComponent

@onready var control: Control = $CanvasLayer/Control
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

func _process(_delta: float) -> void:
	popup()

func popup(do:bool=true):
	if do: 
		popped_up = true
		#local = Global.main.cam.unproject_position(par.global_position)*Global.viewport_mini_scale
		local = Global.main.cam.unproject_position(mark.global_position)*6
		control.position = local
		control.pos = local
		print("local pos: %s" % local)
	else: popped_up = false
