extends "../../gNode.gd"

# slots
const DATA2D_INPUT = 0;
const SIZEX_INPUT = 1;
const SIZEY_INPUT = 2;

const DATA1D_OUTPUT = 0;
const SIZE_OUTPUT = 1;

# normal calculation process
func updateCalc():
	var result = []
	var input = getDataOfPinConn(DATA2D_INPUT)

	for x in range(getDataOfPinConn(SIZEX_INPUT)):
		for y in range(getDataOfPinConn(SIZEY_INPUT)):
			result.append(input[y][x])
