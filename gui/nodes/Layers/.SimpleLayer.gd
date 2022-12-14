extends "../.Layer.gd"

const DATA1D_INPUT = 0
const SIZE_INPUT = 1
const AFUNC_INPUT = 2
const DATA1D_OUTPUT = 0

var lastSizeInput = -1
var lastData1DSize = -1
var LayerIdx

var under_weights : Array
var is_output_layer = false
var learning_rate = 1.0

func init_editor_controls():
	# [Example usage]:
		#var CurrentPlugin = PluginLoader.getCurrentPlugin()
		#print("Building layers ...")
		#var OutputLayer = CurrentPlugin.build_layer(2, 4, PoolRealArray())
		#var HiddenLayer = CurrentPlugin.build_layer(4, 4, PoolRealArray())

		#print("Base layer calls ...")
		#var hiddenLayerResult : PoolRealArray = CurrentPlugin.simple_layer_call(HiddenLayer, [0.5, 0.5, 0.0, 0.0], 0)
		#var result : PoolRealArray = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)

		#print(result)
		#print("Train AI ...")

		#for i in range(100):
			#hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.5, 0.5, 0.0, 0.0], 0)
			#result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
			#var resultWeights : Array = CurrentPlugin.get_layer_weights(OutputLayer)
			#print("Backprop ...")
			#var resultGradient = CurrentPlugin.backprop_layer(OutputLayer, [1.0, 0.0], PoolRealArray(), 0, true, 1.0)
			#var hiddenLayerGradient = CurrentPlugin.backprop_layer(HiddenLayer, resultGradient, resultWeights, 0, false, 1.0)
			#print("backProp done!")

			#hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.0, 0.0, 0.5, 0.5], 0)
			#result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
			#resultWeights = CurrentPlugin.get_layer_weights(OutputLayer)
			#print("Backprop ...")
			#resultGradient = CurrentPlugin.backprop_layer(OutputLayer, [0.0, 1.0], PoolRealArray(), 0, true, 1.0)
			#hiddenLayerGradient = CurrentPlugin.backprop_layer(HiddenLayer, resultGradient, resultWeights, 0, false, 1.0)
			#print("backProp done!")

		#hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.5, 0.5, 0.0, 0.0], 0)
		#result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
		#print(result)

		#hiddenLayerResult = CurrentPlugin.simple_layer_call(HiddenLayer, [0.0, 0.0, 0.5, 0.5], 0)
		#result = CurrentPlugin.simple_layer_call(OutputLayer, hiddenLayerResult, 0)
		#print(result)

	print("[SimpleLayer] Connect with Executer: ", Executer.connect("PrepareBackprop", self, "prepareBackprop"))

func backCalc():
	var CurrentPlugin = PluginLoader.getCurrentPlugin()
	var gradient
	if(is_output_layer):
		var y = getDataOfPinConn(DATA1D_OUTPUT, true)
		print("OutputLayer: y: ", y)
		gradient = CurrentPlugin.backprop_layer(
		#	param							  meaning
		#	-----							  -------
			LayerIdx,						# Index of Layer
			y,								# Optimal output
			PoolRealArray(),				# Not needed (under weights)
			getDataOfPinConn(AFUNC_INPUT),	# Activation func index
			true, 							# is output layer?
			learning_rate					# learning rate
		)
	else:
		var under_grad = getDataOfPinConn(DATA1D_OUTPUT, true)
		gradient = CurrentPlugin.backprop_layer(
		#	param							  meaning
		#	-----							  -------
			LayerIdx,						# Index of Layer
			under_grad,						# gradient of next layer
			under_weights,					# weights before backprop calculation of next layer
			getDataOfPinConn(AFUNC_INPUT),	# Activation func index
			false,							# is output layer?
			learning_rate					# learning rate
		)

	backCalcResults = [gradient]

func prepareBackprop():
	var under_node = getNodeOfConnection(DATA1D_OUTPUT, true)
	if(under_node.has_method("getCurrentWeights")):
		under_weights = under_node.getCurrentWeights()
		is_output_layer = false
	else:
		is_output_layer = true

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
		print("[SimpleLayer] Building Layer, size changed ...")
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

func getCurrentWeights():
	return PluginLoader.getCurrentPlugin().get_layer_weights(LayerIdx)
