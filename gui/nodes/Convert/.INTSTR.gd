extends "../../gNode.gd"

const INT_INPUT = 0
const STR_OUTPUT = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func updateCalc():
	outputs = [str(getDataOfPinConn(INT_INPUT))]
