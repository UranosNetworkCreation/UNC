extends Node

func _ready():
	# center the window
	OS.center_window()

	# load editor
	print("[Main] Load Editor: ", get_tree().change_scene("res://gui/Editor.tscn"))
