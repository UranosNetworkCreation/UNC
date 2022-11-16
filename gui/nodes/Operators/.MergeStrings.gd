extends "../../gNode.gd"

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const STRING_A_INPUT = 0
const STRING_B_INPUT = 1
const STRING_OUTPUT = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func updateCalc():
	print("Merge Strings ...")
	outputs = [getDataOfPinConn(STRING_A_INPUT) + getDataOfPinConn(STRING_B_INPUT)]
