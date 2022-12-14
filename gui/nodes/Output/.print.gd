extends "../.Output.gd"

const STRING_INPUT = 0
var OutputPreset
var OutputInst
var OutputPanel

func init_editor_controls():
	print("[gNode][print] Connect with Executer: ", Executer.connect("ExecuteSoftware", self, "_on_software_exe"))
	OutputPanel = get_node("../../Inspector/TabContainer/Output/VBoxContainer")
	OutputPreset = load("res://gui/Output/text.tscn")
	OutputInst = OutputPreset.instance()
	OutputPanel.add_child(OutputInst)

func _on_software_exe():
	updateConnections()
	OutputInst.set_value(getDataOfPinConn(STRING_INPUT))

func _exit_tree():
	if(!is_preview):
		OutputInst.queue_free()
