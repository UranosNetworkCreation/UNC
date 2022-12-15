extends "../../gNode.gd"

# slots
const STRING_A_INPUT = 0
const STRING_B_INPUT = 1
const STRING_OUTPUT = 0

# Calculation process during training
func backCalc():
	print("[gNode][MergeStrings] Cannot handle backCalc. Operation invalid.")
	# Assign results to output array
	backCalcResults = ["<undefined>", "<undefined>"]

# Normal calculation process
func updateCalc():
	# Assign results to output array
	outputs = [getDataOfPinConn(STRING_A_INPUT) + getDataOfPinConn(STRING_B_INPUT)]
