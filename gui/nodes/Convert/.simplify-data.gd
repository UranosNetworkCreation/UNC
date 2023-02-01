extends "../../gNode.gd"

onready var BlockSizeSpinBox = $BlockSize

const DATA1D_INPUT = 0
const DATA1D_OUTPUT = 0

func _ready():
	pass # Replace with function body.

func updateCalc():
	var result = []
	
	var iblock_index = 0
	var block_sum = 0
	for num in getDataOfPinConn(DATA1D_INPUT):
		block_sum += num
		iblock_index += 1
		
		if((iblock_index) == BlockSizeSpinBox.value):
			result.push_back(block_sum/BlockSizeSpinBox.value)	
			block_sum = 0
			iblock_index = 0
		
	outputs = [result]

# Will only return the average
func backCalc():
	var result = []
	for num in getDataOfPinConn(DATA1D_OUTPUT, true):
		for i in range(BlockSizeSpinBox.value):
			result.push_back(num)
			
	backCalcResults = [result]
