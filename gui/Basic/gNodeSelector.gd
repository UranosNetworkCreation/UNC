extends HBoxContainer

# Preload gNode Class
const gNode = preload("../gNode.gd")

# NodePath of GraphEdit
export var GEditPath : NodePath = "../../../../../../../../../GraphEdit"

# essencial nodes
var selectLbl : Label
var LEdit : LineEdit
var GEdit : GraphEdit

# signals
signal gNodeSelected(node)

func _ready():
	# Assign nodes to vars and connect base signals
	selectLbl = get_node("SelectLabel/Label")
	print("[gNodeSelector] Connect: ", selectLbl.connect("ungrap", self, "_on_selection_done"))
	GEdit = get_node(GEditPath)
	LEdit = get_node("LineEdit")

func _process(_delta):
	pass

func _on_selectBtn_button_down():
	# Grap the Label when the button is pressed
	selectLbl.grap()

# Returns true if the selected node exists
func is_gNodevalid():
	return (getValue() != "" && GEdit.get_node_or_null(getValue()) != null)

func _on_selection_done():
	# Exit if mouse is not in Graph
	if(!BaseFuncs.touch_mouse(GEdit.get_global_rect())):
		return

	# Checkout the child which is touched by the mouse
	for child in GEdit.get_children():
		if(child is gNode):
			if(BaseFuncs.touch_mouse(child.get_global_rect())):
				# Update LineEdit and send signal
				LEdit.text = child.name
				emit_signal("gNodeSelected", child)
				return

func getValue():
	return LEdit.text

func getSelectedNode():
	# get node from Graph
	return GEdit.get_node(LEdit.text)
