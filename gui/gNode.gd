extends "dataNode.gd"

# Base class for all nodes

# essencial nodes
var phantomInput
var preview

# packed
var packed : PackedScene

# forward calculation
var calculated = false
var outputs = []

# Editor
var GraphE : GraphEdit

# connections
var input_conns = []
var output_conns = []

# state
var is_preview = false

# backward calculation
var backCCalculated = false
var backCalcResults = []

# number of slots
export var slotCount : int

# Keywords
const CONN_NAME = 0
const CONN_PORT = 1
const NO_CONN = ["-1", "-1"]

# node specific virtual functions
func init_editor_controls():
	pass

func updateCalc():
	pass

func backCalc():
	pass

func init_as_node(packedPth):
	.init_as_node(packedPth)

	# Connect functions with signals
	print("[gNode] Connect signal: ", connect("close_request", self, "_on_close"))
	print(
		"[gNode] Connect with Excecuter: ",
		Executer.connect("PrepareExecuting", self, "resetCalc"), ", ",
		Executer.connect("PrepareBackprop", self, "resetCalc")
	)

	# Init ctrls
	init_editor_controls()

	# Assign nodes to vars
	GraphE = get_parent()

func init_as_preview(phantomID, previewInst, packedPth):
	# Assign values to vars
	phantomInput = phantomID
	packedPath = packedPth
	packed = load(packedPath)
	preview = previewInst

	# Connect with phantomInputDetector
	phantomInput.connect("button_down", self, "_on_grap")

	# set preview
	is_preview = true

# Returns the connected node
func getNodeOfConnection(
	slot : int,
	backprop : bool = false
):
	if(!backprop):
		return get_parent().get_node(input_conns[slot][CONN_NAME])
	else:
		return get_parent().get_node(output_conns[slot][CONN_NAME])

# Returns the specific calculated data of the connected node
func getDataOfPinConn(
	slot : int,
	backprop : bool = false,
	no_conn = "<undefined>"
):
	if(!backprop):
		# check if it's connected
		if(input_conns[slot] == NO_CONN):
			return no_conn
		# get the node
		var node = get_parent().get_node(input_conns[slot][CONN_NAME])
		# Return the value
		return node.getPinValue(input_conns[slot][CONN_PORT])
	else:
		# check if it's connected
		if(output_conns[slot] == NO_CONN):
			return no_conn
		# get the node
		var node = get_parent().get_node(output_conns[slot][CONN_NAME])
		# Return the value
		return node.getBackCalcValue(output_conns[slot][CONN_PORT])

# Updates the connection arrays
func updateConnections():
	# Reset arrays
	input_conns = []
	output_conns = []
	for _i in range(slotCount):
		input_conns.append(NO_CONN)
		output_conns.append(NO_CONN)

	# Update arrays
	for conn in GraphE.get_connection_list():
		# Check if it is an output or input
		if(conn.from == name):
			output_conns[conn.from_port] = [conn.to, conn.to_port]
		if(conn.to == name):
			input_conns[conn.to_port] = [conn.from, conn.from_port]
	#print("IConnections of ", name, ": ", input_conns, ", ", output_conns)

# reset th ecalculation
func resetCalc():
	backCCalculated = false
	calculated = false

# Returns a specific value of the self calculated output
func getPinValue(var id : int):
	# calculate if it's not calculated yet
	if(!calculated):
		updateConnections()
		updateCalc()
		calculated = true

	# return the requested entry of the array
	return outputs[id]

# Returns a specific value of the self calculated output during the backcalc
func getBackCalcValue(var id : int):
	# calculate if it's not calculated yet
	if(!backCCalculated):
		backCalc()
		backCCalculated = true

	# return the requested entry of the array
	return backCalcResults[id]

# Handles
# -------
func _on_close():
	# Trigger the close event of the Editor
	var GraphP = get_parent()
	GraphP._on_GraphEdit_delete_nodes_request([self.name])

func _on_grap():
	print(self, " grabed.")
	preview.begin_grabbing_node(self)
