extends WindowDialog

# Section node
export var SectionPth : NodePath
var Section

# Mouse Follower node
export var AddNodeMFollowerPth : NodePath
var AddNodeMouseFollower

# Resource Syncronizer
const ResDataSync = preload("res://gui//ResDataSync.gd")

# vars
var grapednode

# GraphEditor
var GEdit : GraphEdit

# node presets
var inputNodePreset = preload("res://gui/Training/inputNodePreset.tscn")
var outputNodePreset = preload("res://gui/Training/outputNodePreset.tscn")

# slot types
const SLOTTYPE_INT = 1
const SLOTTYPE_STRING = 3
const SLOTTYPE_BOOLEAN = 8

func _ready():
	# Assign nodes to vars
	AddNodeMouseFollower = get_node(AddNodeMFollowerPth)
	Section = get_node(SectionPth)
	GEdit = get_node("GraphEdit")

	# Connect ungrap function with mouse follower
	AddNodeMouseFollower.connect("ungrap", self, "_on_ungrap")

# Builds an inputnode
func buildInputNode():
	# instance preset
	var result = inputNodePreset.instance()
	# get selected node
	var selectedNode = Section.BeginSelector.getSelectedNode()
	
	# Add controls
	for child in selectedNode.get_children():
		if(child is LineEdit):
			var ledit = LineEdit.new()
			ledit.placeholder_text = child.placeholder_text
			result.add_child(ledit)
		if(child is SpinBox):
			result.add_child(SpinBox.new())
		if(child is TextEdit):
			result.add_child(TextEdit.new())
		if(child is CheckBox):
			result.add_child(CheckBox.new())
	
	return result

# Builds an outputnode
func buildOutputNode():
	# instance preset
	var result = outputNodePreset.instance()
	# get selected node
	var selectedNode : GraphNode = Section.EndSelector.getSelectedNode()
	
	# Add controls
	for slot in selectedNode.get_child_count():
		if(selectedNode.is_slot_enabled_left(slot)):
			var newCtrl
			match(selectedNode.get_slot_type_left(slot)):
				SLOTTYPE_BOOLEAN:
					newCtrl = CheckBox.new()
					newCtrl.hint_tooltip = "boolean"
				SLOTTYPE_INT:
					newCtrl = SpinBox.new()
					newCtrl.hint_tooltip = "int"
				SLOTTYPE_STRING:
					newCtrl = LineEdit.new()
					newCtrl.placeholder_text = "string"
			result.add_child(newCtrl)
	return result

func _on_ungrap():
	# Exit if mouse is not in editor
	if(!BaseFuncs.touch_mouse(GEdit.get_global_rect())):
		return

	# Add inst at mouse position to GraphEditor
	var inst = grapednode
	inst.offset = GEdit.scroll_offset + GEdit.get_local_mouse_position()
	GEdit.add_child(inst)

# Button handles
func _on_AddOutput_button_down():
	AddNodeMouseFollower.grap()
	grapednode = buildOutputNode()

func _on_AddInput_button_down():
	AddNodeMouseFollower.grap()
	grapednode = buildInputNode()

# collect Data of node
func collectData(node):
	var resSync = ResDataSync.new(node)
	return resSync.collectData()

# Returns all datasets
func getDataSets() -> Array:
	var result : Array = Array()
	# Build the dataset from the connections
	for conn in GEdit.get_connection_list():
		var dataset : Array = Array()
		dataset.push_back(collectData(GEdit.get_node(conn.from)))
		dataset.push_back(collectData(GEdit.get_node(conn.to)))
		result.push_back(dataset)
	print("[DatasetEditor] Datasets: ", result)
	return result
