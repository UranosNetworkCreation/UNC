extends "../../gNode.gd"


const INPUT_DATA1D = 0
const OUTPUT_STRING = 0

func backCalc():
	backCalcResults = [BaseFuncs.StrToArray(getDataOfPinConn(OUTPUT_STRING, true))]

func updateCalc():
	outputs = [str(getDataOfPinConn(INPUT_DATA1D))]