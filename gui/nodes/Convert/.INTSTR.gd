extends "../../gNode.gd"

const INT_INPUT = 0
const STR_OUTPUT = 0

func backCalc():
	backCalcResults = [int(getDataOfPinConn(STR_OUTPUT, true))]

func updateCalc():
	outputs = [str(getDataOfPinConn(INT_INPUT))]