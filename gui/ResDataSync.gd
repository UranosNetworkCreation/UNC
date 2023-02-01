extends Object

# Node for the ResDataSync
var bNode : Node

# constructor
func _init(var baseNode : Node):
	# Assign values to vars
	bNode = baseNode

# returns true if th egiven nod eis a LineEdit, TextEdit, SpinBox or ChckBox
func isDataField(var node) -> bool:
	if(node is LineEdit):
		return true
	if(node is TextEdit):
		return true
	if(node is SpinBox):
		return true
	if(node is CheckBox):
		return true
	return false

# returns the data of an input node
func getData(var node):
	if(node is LineEdit):
		return node.text
	if(node is TextEdit):
		return node.text
	if(node is SpinBox):
		return node.value
	if(node is CheckBox):
		return node.pressed

# sets the data of an input node
func setData(var node, var data):
	if(node is LineEdit):
		node.call_deferred("set_text", data)
	if(node is TextEdit):
		node.call_deferred("set_text", data)
	if(node is SpinBox):
		node.call_deferred("set_value", data)
	if(node is CheckBox):
		node.call_deferred("set_pressed", data)

# collects nodes data
func collectData() -> Array:
	# Create empty array for the result
	var result : Array = []
	for child in bNode.get_children():
		# Add the child's data to the result if it is a dataField
		if(isDataField(child)):
			result.append(getData(child))
	return result

# Loads a data array
func loadData(var data : Array):
	# counter
	var data_idx : int = 0
	for child in bNode.get_children():
		if(isDataField(child)):
			# Apply data
			setData(child, data[data_idx])
			# increment counter
			data_idx += 1
