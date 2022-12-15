extends "../../gNode.gd"

# Slots
const INPUT_DATA1D = 0
const OUTPUT_STRING = 0

# Calculation process during training
func backCalc():
	# Assign results to output array
	backCalcResults = [BaseFuncs.StrToArray(getDataOfPinConn(OUTPUT_STRING, true))]

# Normal calculation process
func updateCalc():
	# Assign results to output array
	outputs = [str(getDataOfPinConn(INPUT_DATA1D))]