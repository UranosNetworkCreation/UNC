extends Object

var bNode : Node

func _init(var baseNode : Node):
    bNode = baseNode

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

func getData(var node):
    if(node is LineEdit):
        return node.text
    if(node is TextEdit):
        return node.text
    if(node is SpinBox):
        return node.value
    if(node is CheckBox):
        return node.pressed

func setData(var node, var data):
    if(node is LineEdit):
        node.text = data
    if(node is TextEdit):
        node.text = data
    if(node is SpinBox):
        node.value = data
    if(node is CheckBox):
        node.pressed = data

func collectData() -> Array:
    var result : Array = []
    for child in bNode.get_children():
        if(isDataField(child)):
            result.append(getData(child))
    return result

func loadData(var data : Array):
    var data_idx : int = 0
    for child in bNode.get_children():
        if(isDataField(child)):
            setData(child, data[data_idx])
            data_idx += 1