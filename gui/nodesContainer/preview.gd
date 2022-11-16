extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var phantomIDPreset = preload("phantomInputDetector.tscn")
var addingNodeToGraph = false
var MainGraphEditor : GraphEdit
var currentEditorNode : GraphNode

func isMouseInEditor():
	var ERect
	ERect = MainGraphEditor.get_global_rect()
	var mouse_pos = get_global_mouse_position()
	return(
		ERect.position.x < mouse_pos.x and
		(ERect.position.x + ERect.size.x) > mouse_pos.x and
		ERect.position.y < mouse_pos.y and
		(ERect.position.y + ERect.size.y) > mouse_pos.y
	)

func setGEditor(node):
	MainGraphEditor = node 

func _ready():
	print("[Preview] Connecting signal: ", get_tree().get_root().connect("size_changed", self, "_on_window_size_changed"), ".")
	for child in $preview.get_children():
		child.hide()

func _input(event):
	if event is InputEventMouseButton:
		var MBInput : InputEventMouseButton = event as InputEventMouseButton
		if(!MBInput.pressed):
			if(addingNodeToGraph):
				end_grabbing_node()

func removeAllVChilds():
	for child in $preview.get_children():
		#get_node("Viewport").remove_child(child)
		print(child)

func addNode(node, packed):
	#removeAllVChilds()
	$preview.add_child(node)
	var phantomID = phantomIDPreset.instance()
	phantomID.rect_position = node.offset
	phantomID.rect_size = node.get_rect().size
	$InputBlocker.add_child(phantomID)
	node.init_as_preview(phantomID, self, packed)

func begin_grabbing_node(node):
	addingNodeToGraph = true
	$mouseDragElement.visible = true
	currentEditorNode = node

func end_grabbing_node():
	if(isMouseInEditor()):
		var newENode = currentEditorNode.packed.instance()
		MainGraphEditor.add_child(newENode)
		var LMPos = MainGraphEditor.get_local_mouse_position()
		newENode.offset.x = LMPos.x + MainGraphEditor.scroll_offset.x
		newENode.offset.y = LMPos.y + MainGraphEditor.scroll_offset.y
		newENode.init_as_node()
	$mouseDragElement.visible = false
	addingNodeToGraph = false

func _process(_delta):
	if($mouseDragElement.visible):
		$mouseDragElement.rect_position = get_local_mouse_position()
		if(isMouseInEditor()):
			$mouseDragElement.modulate.a = 1.0
		else:
			$mouseDragElement.modulate.a = 0.5

func _on_window_size_changed():
	$preview.scroll_offset = Vector2(0, 0)
