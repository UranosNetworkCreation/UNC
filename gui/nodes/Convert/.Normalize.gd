extends "../../gNode.gd"

const DATA1D_INPUT = 0
const DATA1D_OUTPUT = 0

var NumInput : SpinBox

func _ready():
	NumInput = get_node("SpinBox")

func backCalc():
	var result = BaseFuncs.MultiplyArray(getDataOfPinConn(DATA1D_OUTPUT, true), NumInput.value)
	backCalcResults = [result]

func updateCalc():
	var result : PoolRealArray = BaseFuncs.DivArray(getDataOfPinConn(DATA1D_INPUT), NumInput.value)
	outputs = [result]
