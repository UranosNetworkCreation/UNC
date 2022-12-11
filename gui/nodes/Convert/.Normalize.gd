extends "../../gNode.gd"

const DATA1D_INPUT = 0
const DATA1D_OUTPUT = 0

var NumInput : SpinBox

func _ready():
	NumInput = get_node("SpinBox")

func DivArray(arr, div : float):
	var result : PoolRealArray = PoolRealArray()
	for item in arr:
		var itemf : float = item
		var divresult : float = itemf/div
		result.append(divresult)

	return result

func updateCalc():
	var result : PoolRealArray = DivArray(getDataOfPinConn(DATA1D_INPUT), NumInput.value)
	outputs = [result]
