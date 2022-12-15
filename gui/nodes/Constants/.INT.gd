extends "../../gNode.gd"

# Slots
const CONST_VALUE_OUTPUT = 0

# Essencial nodes
var numinput : SpinBox

func _ready():
	# Assign nodes to vars
	numinput = get_node("SpinBox")

func updateCalc():
	# Update output array
	outputs = [numinput.value]