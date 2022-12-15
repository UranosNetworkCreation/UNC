extends "../.Output.gd"

# slots
const STRING_INPUT = 0

# essencial nodes
var OutputPreset
var OutputInst
var OutputPanel

func init_editor_controls():
	print("[gNode][print] Connect with Executer: ", Executer.connect("ExecuteSoftware", self, "_on_software_exe"))
	# Get output panel
	OutputPanel = get_node("../../Inspector/TabContainer/Output/VBoxContainer")
	# load preset
	OutputPreset = load("res://gui/Output/text.tscn")
	# Instance preset and add to panel
	OutputInst = OutputPreset.instance()
	OutputPanel.add_child(OutputInst)

func _on_software_exe():
	updateConnections()
	# Update panel
	OutputInst.set_value(getDataOfPinConn(STRING_INPUT))

func _exit_tree():
	if(!is_preview):
		# remove inst from panel
		OutputInst.queue_free()
