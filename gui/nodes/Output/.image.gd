extends "../.Output.gd"

# slots
const DATA1D_INPUT = 0
const SIZEX_INPUT = 1
const SIZEY_INPUT = 2
const FORMAT_INPUT = 3
const MIPMAP_INPUT = 4

# essencial nodes
var OutputPreset
var OutputInst
var OutputPanel


func init_editor_controls():
	print("[gNode][imageOutput] Connect with Executer: ", Executer.connect("ExecuteSoftware", self, "_on_software_exe"))
	# Get output panel
	OutputPanel = get_node("../../Inspector/TabContainer/Output/VBoxContainer")
	# load preset
	OutputPreset = load("res://gui/Output/image.tscn")
	# Instance preset and add to panel
	OutputInst = OutputPreset.instance()
	OutputPanel.add_child(OutputInst)

func _on_software_exe():
	updateConnections()

	# Create image container
	var img = Image.new()

	# set data and trigger connection
	img.data = {
		"data": getDataOfPinConn(DATA1D_INPUT),
		"format": getDataOfPinConn(FORMAT_INPUT),
		"height": getDataOfPinConn(SIZEY_INPUT),
		"mipmaps": getDataOfPinConn(MIPMAP_INPUT),
		"width": getDataOfPinConn(SIZEX_INPUT)
	}

	# Update panel
	OutputInst.set_value(img)

func _exit_tree():
	if(!is_preview):
		# remove inst from panel
		OutputInst.queue_free()
