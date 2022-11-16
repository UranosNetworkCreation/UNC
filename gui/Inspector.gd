extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var LastUpdatedLabel


# Called when the node enters the scene tree for the first time.
func _ready():
	LastUpdatedLabel = get_node("TabContainer/Output/VBoxContainer/HBoxContainer/value")
	print("[Inspector] Connecting with Executer: ", Executer.connect("ExecutingDone", self, "_on_exe_done"))


func _on_exe_done():
	LastUpdatedLabel.text = Time.get_time_string_from_system()
