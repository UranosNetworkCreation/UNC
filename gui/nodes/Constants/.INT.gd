extends "../../gNode.gd"

const CONST_VALUE_OUTPUT = 0
var numinput : SpinBox

# Called when the node enters the scene tree for the first time.
func _ready():
	numinput = get_node("SpinBox")

func updateCalc():
	outputs = [numinput.value]

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
