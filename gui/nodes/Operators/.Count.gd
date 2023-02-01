extends "../../gNode.gd"

const DATA1D_INPUT = 0
const INT_OUTPUT = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func updateCalc():
	var arr : Array = getDataOfPinConn(DATA1D_INPUT)
	outputs = [arr.size()]
