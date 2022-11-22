extends "../../gNode.gd"


const INPUT_DATA1D = 0
const OUTPUT_STRING = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func updateCalc():
	outputs = [str(getDataOfPinConn(INPUT_DATA1D))]