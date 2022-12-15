extends "../../gNode.gd"

# slots
const INT_INPUT = 0
const STR_OUTPUT = 0

# calculation process during training
func backCalc():
	backCalcResults = [int(getDataOfPinConn(STR_OUTPUT, true))]

# normal calculation process
func updateCalc():
	outputs = [str(getDataOfPinConn(INT_INPUT))]