extends "../../gNode.gd"

# Pins
const STRING_A_INPUT = 0
const STRING_B_INPUT = 1
const STRING_OUTPUT = 0

func backCalc():
	print("[gNode][MergeStrings] Cannot handle backCalc. Operation invalid.")
	backCalcResults = ["<undefined>", "<undefined>"]

func updateCalc():
	outputs = [getDataOfPinConn(STRING_A_INPUT) + getDataOfPinConn(STRING_B_INPUT)]
