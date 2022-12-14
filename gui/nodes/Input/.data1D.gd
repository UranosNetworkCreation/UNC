extends "../.Input.gd"

const DATA1D_OUTPUT = 0

var LEdit

func _ready():
	LEdit = get_node("LineEdit")

func updateCalc():
	outputs = [BaseFuncs.StrToArray(LEdit.text)]