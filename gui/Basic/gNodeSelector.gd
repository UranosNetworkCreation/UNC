extends HBoxContainer

const gNode = preload("../gNode.gd")

export var GEditPath : NodePath = "../../../../../../../../../GraphEdit"

var selectLbl : Label
var LEdit : LineEdit
var GEdit : GraphEdit

signal gNodeSelected(node)

func _ready():
	selectLbl = get_node("SelectLabel/Label")
	print("[gNodeSelector] Connect: ", selectLbl.connect("ungrap", self, "_on_selection_done"))
	GEdit = get_node(GEditPath)
	LEdit = get_node("LineEdit")

func _process(_delta):
	pass

func _on_selectBtn_button_down():
	selectLbl.grap()

func _on_selection_done():
	if(!BaseFuncs.touch_mouse(GEdit.get_global_rect())):
		return
	for child in GEdit.get_children():
		if(child is gNode):
			if(BaseFuncs.touch_mouse(child.get_global_rect())):
				LEdit.text = child.name
				emit_signal("gNodeSelected", child)
				return
