extends Control

# essencial nodes
var LastUpdatedLabel

func _ready():
	# Assign nodes to vars
	LastUpdatedLabel = get_node("TabContainer/Output/VBoxContainer/HBoxContainer/value")
	# connect with Executer
	print("[Inspector] Connecting with Executer: ", Executer.connect("ExecutingDone", self, "_on_exe_done"))

# Handles
# -------
func _on_exe_done():
	# Update label
	LastUpdatedLabel.text = Time.get_time_string_from_system()
