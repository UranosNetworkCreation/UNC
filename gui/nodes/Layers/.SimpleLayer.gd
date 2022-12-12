extends "../.backPropAble.gd"

const DATA1D_INPUT = 0
const SIZE_INPUT = 1
const AFUNC_INPUT = 2
const DATA1D_OUTPUT = 0

var lastSizeInput = -1
var lastData1DSize = -1
var LayerIdx

# Called when the node enters the scene tree for the first time.
func init_editor_controls():
	#print("[SimpleLayer] Init ...")
	#var Layer = PluginLoader.plugins[0].build_layer(4, 10, PoolRealArray())
	#print("[SimpleLayer] Result ...")
	#var result : PoolRealArray = PluginLoader.plugins[0].simple_layer_call(Layer, [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 0.10], 0)
	#print(result)
	var CurrentPlugin = PluginLoader.getCurrentPlugin()
	print("Building layers ...")
	var OutputLayer = CurrentPlugin.build_layer(2, 4, PoolRealArray())
	var HiddenLayer = CurrentPlugin.build_layer(4, 4, PoolRealArray())

	print("Base layer calls ...")
	var hiddenLayerResult : PoolRealArray = CurrentPlugin.simple_layer_call(HiddenLayer, [0.5, 0.5, 0.0, 0.0], 0)
	var result : PoolRealArray = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)

	print(result)
	print("Train AI ...")

	for i in range(100):
		hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.5, 0.5, 0.0, 0.0], 0)
		result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
		var resultWeights : Array = CurrentPlugin.get_layer_weights(OutputLayer)
		#print("Backprop ...")
		var resultGradient = CurrentPlugin.backprop_layer(OutputLayer, [1.0, 0.0], PoolRealArray(), 0, true, 1.0)
		var hiddenLayerGradient = CurrentPlugin.backprop_layer(HiddenLayer, resultGradient, resultWeights, 0, false, 1.0)
		#print("backProp done!")

		hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.0, 0.0, 0.5, 0.5], 0)
		result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
		resultWeights = CurrentPlugin.get_layer_weights(OutputLayer)
		#print("Backprop ...")
		resultGradient = CurrentPlugin.backprop_layer(OutputLayer, [0.0, 1.0], PoolRealArray(), 0, true, 1.0)
		hiddenLayerGradient = CurrentPlugin.backprop_layer(HiddenLayer, resultGradient, resultWeights, 0, false, 1.0)
		#print("backProp done!")

	hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.5, 0.5, 0.0, 0.0], 0)
	result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
	print(result)

	hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.0, 0.0, 0.5, 0.5], 0)
	result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
	print(result)

func hasShapeChanged():
	if(lastSizeInput != getDataOfPinConn(SIZE_INPUT)):
		lastSizeInput = getDataOfPinConn(SIZE_INPUT)
		return true
	if(lastData1DSize != len(getDataOfPinConn(DATA1D_INPUT))):
		lastData1DSize = len(getDataOfPinConn(DATA1D_INPUT))
		return true
	return false

func updateCalc():
	outputs = []
	if(hasShapeChanged()):
		print("[SimpleLayer] Building Layer ...")
		LayerIdx = PluginLoader.getCurrentPlugin().build_layer(
			getDataOfPinConn(SIZE_INPUT),
			len(getDataOfPinConn(DATA1D_INPUT)),
			PoolRealArray()
		)
	print("[SimpleLayer] Call Layer and update output ...")
	outputs.append(
		PluginLoader.getCurrentPlugin().simple_layer_call(
			LayerIdx,
			getDataOfPinConn(DATA1D_INPUT),
			getDataOfPinConn(AFUNC_INPUT)
		)
	)