extends "../../gNode.gd"

const CONST_VALUE_OUTPUT = 0
var strinput : LineEdit

# Called when the node enters the scene tree for the first time.
func _ready():
	strinput = get_node("LineEdit")

func updateCalc():
	outputs = [strinput.text]
