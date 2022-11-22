extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	OS.center_window()
	print("[Main] Load Editor: ", get_tree().change_scene("res://gui/Editor.tscn"))
