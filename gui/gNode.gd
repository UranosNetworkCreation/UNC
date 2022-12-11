extends GraphNode

var phantomInput
var preview
var packedPath : String
var packed : PackedScene
var calculated = false
var outputs = []
var GraphE : GraphEdit
var input_conns = []
var output_conns = []
var is_preview = false
export var slotCount : int

const CONN_NAME = 0
const CONN_PORT = 1
const NO_CONN = ["-1", "-1"]

const ResDataSync = preload("ResDataSync.gd")
const NodeData = preload("res://kernel/resources/node.gd")

var DataSync : ResDataSync

func init_editor_controls():
	pass

# Called when the node enters the scene tree for the first time.
func init_as_node(packedPth):
	packedPath = packedPth
	print("[gNode] Connect signal: ", connect("close_request", self, "_on_close"))
	print("[gNode] Connect signal: ", Executer.connect("PrepareExecuting", self, "resetCalc"))
	init_editor_controls()
	GraphE = get_parent()
	DataSync = ResDataSync.new(self)

func updateCalc():
	pass

func getDataOfPinConn(
	slot : int,
	backprop : bool = false,
	no_conn = "<undefined>"
):
	if(!backprop):
		if(input_conns[slot] == NO_CONN):
			return no_conn
		var node = get_parent().get_node(input_conns[slot][CONN_NAME])
		return node.getPinValue(input_conns[slot][CONN_PORT])
	else:
		if(output_conns[slot] == NO_CONN):
			return no_conn
		var node = get_parent().get_node(output_conns[slot][CONN_NAME])
		return node.getBackPropValue(output_conns[slot][CONN_PORT])

func updateConnections():
	input_conns = []
	output_conns = []
	for _i in range(slotCount):
		input_conns.append(NO_CONN)
		output_conns.append(NO_CONN)
	for conn in GraphE.get_connection_list():
		if(conn.from == name):
			output_conns[conn.from_port] = [conn.to, conn.to_port]
		if(conn.to == name):
			input_conns[conn.to_port] = [conn.from, conn.from_port]
	print("IConnections of ", name, ": ", input_conns, ", ", output_conns)

func resetCalc():
	calculated = false

func getPinValue(var id : int):
	if(!calculated):
		updateConnections()
		updateCalc()
	return outputs[id]

func _on_close():
	var GraphP = get_parent()
	GraphP._on_GraphEdit_delete_nodes_request([self.name])

func init_as_preview(phantomID, previewInst, packedPth):
	phantomInput = phantomID
	packedPath = packedPth
	packed = load(packedPath)
	preview = previewInst
	phantomInput.connect("button_down", self, "_on_grap")
	is_preview = true

func _on_grap():
	print(self, " grabed.")
	preview.begin_grabbing_node(self)

func getNodeData() -> NodeData:
	var data : NodeData = NodeData.new()
	data.data = DataSync.collectData()
	data.offset = self.offset
	data.type = self.packedPath
	data.name = self.name

	return data
