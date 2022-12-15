extends "../.Input.gd"

# slots
const DATA1D_OUTPUT = 0

# essencial nodes
var LEdit

func _ready():
	# Assign nodes to vars
	LEdit = get_node("LineEdit")

# normal calculation process
func updateCalc():
	outputs = [BaseFuncs.StrToArray(LEdit.text)]