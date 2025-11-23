extends Node

signal boot_laptop
signal hinge_anim(duration:float)

var framework_13 : Framework13
var main : Main
var viewport_mini_scale : float = 6

var current_outline : OutlineComponent
signal update_outlines
