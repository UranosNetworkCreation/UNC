extends "../../gNode.gd"

# slots
const DATA1D_INPUT = 0
const DATA1D_OUTPUT = 0

# essencial nodes
var NumInput : SpinBox

func _ready():
	# Assign values to nodes
	NumInput = get_node("SpinBox")

# calculation process during training
func backCalc():
	var result = BaseFuncs.MultiplyArray(getDataOfPinConn(DATA1D_OUTPUT, true), NumInput.value)
	backCalcResults = [result]

# normal calculation process
func updateCalc():
	var result : PoolRealArray = BaseFuncs.DivArray(getDataOfPinConn(DATA1D_INPUT), NumInput.value)
	outputs = [result]
