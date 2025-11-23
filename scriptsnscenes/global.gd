extends Node

signal boot_laptop
signal hinge_anim(duration:float)

var framework_13 : Framework13
var main : Main


const OUTLINE_MATERIAL = preload("uid://copb41ysaafm3")
func outline_mesh(mesh:MeshInstance3D, toggle_on:bool=true):
	if toggle_on:
		mesh.material_overlay = OUTLINE_MATERIAL
	else:
		mesh.material_overlay = null
