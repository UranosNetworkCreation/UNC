extends "../../gNode.gd"

# slots
const CONST_VALUE_OUTPUT = 0

# essencial nodes
var strinput : LineEdit


func _ready():
	# Assign nodes to vars
	strinput = get_node("LineEdit")

func updateCalc():
	# Update output array
	outputs = [strinput.text]
