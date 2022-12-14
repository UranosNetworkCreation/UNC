extends "../.Output.gd"


const DATA1D_INPUT = 0
const SIZEX_INPUT = 1
const SIZEY_INPUT = 2
const FORMAT_INPUT = 3
const MIPMAP_INPUT = 4

var OutputPreset
var OutputInst
var OutputPanel


func init_editor_controls():
	print("[gNode][imageOutput] Connect with Executer: ", Executer.connect("ExecuteSoftware", self, "_on_software_exe"))
	OutputPanel = get_node("../../Inspector/TabContainer/Output/VBoxContainer")
	OutputPreset = load("res://gui/Output/image.tscn")
	OutputInst = OutputPreset.instance()
	OutputPanel.add_child(OutputInst)

func _on_software_exe():
	updateConnections()
	var img = Image.new()
	img.data = {
		"data": getDataOfPinConn(DATA1D_INPUT),
		"format": getDataOfPinConn(FORMAT_INPUT),
		"height": getDataOfPinConn(SIZEY_INPUT),
		"mipmaps": getDataOfPinConn(MIPMAP_INPUT),
		"width": getDataOfPinConn(SIZEX_INPUT)
	}
	OutputInst.set_value(img)

func _exit_tree():
	if(!is_preview):
		OutputInst.queue_free()
