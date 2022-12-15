extends Control

# Preload preset for the phantomInputDetector
var phantomIDPreset = preload("phantomInputDetector.tscn")

# vars
var addingNodeToGraph = false

# essencial nodes
var MainGraphEditor : GraphEdit
var currentEditorNode : GraphNode

# Returns true if the mouse touches the editor space
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

# set GraphEditor
func setGEditor(node):
	MainGraphEditor = node 

func _ready():
	# Connect signals
	print("[Preview] Connecting signal: ", get_tree().get_root().connect("size_changed", self, "_on_window_size_changed"), ".")
	
	# Hide all control elements in the preview graph
	for child in $preview.get_children():
		child.hide()

func _input(event):
	# Stop grabbing node if left mouse btn up
	if event is InputEventMouseButton:
		var MBInput : InputEventMouseButton = event as InputEventMouseButton
		if(!MBInput.pressed):
			if(addingNodeToGraph):
				end_grabbing_node()

# Remove all childs (not used anymore)
func removeAllVChilds():
	for child in $preview.get_children():
		#get_node("Viewport").remove_child(child)
		print(child)

# Add node to preview
func addNode(node, packedPth : String):
	#removeAllVChilds()
	$preview.add_child(node)

	# Create phantomInputDetector
	var phantomID = phantomIDPreset.instance()
	phantomID.rect_position = node.offset
	phantomID.rect_size = node.get_rect().size
	$InputBlocker.add_child(phantomID)

	# Init node
	node.init_as_preview(phantomID, self, packedPth)

func begin_grabbing_node(node):
	# Update vars
	addingNodeToGraph = true
	$Canvas/mouseDragElement.visible = true
	currentEditorNode = node

func end_grabbing_node():
	# Add node to editor when mouse is in editor
	if(isMouseInEditor()):
		# Instance node
		var newENode = currentEditorNode.packed.instance()
		MainGraphEditor.add_child(newENode)

		# Set pos to mouse pos
		var LMPos = MainGraphEditor.get_local_mouse_position()
		newENode.offset.x = LMPos.x + MainGraphEditor.scroll_offset.x
		newENode.offset.y = LMPos.y + MainGraphEditor.scroll_offset.y
		newENode.init_as_node(currentEditorNode.packedPath)
	
	# Hide mouseDragElement
	$Canvas/mouseDragElement.visible = false
	addingNodeToGraph = false

func _process(_delta):
	# Update drag element postion if visible
	if($Canvas/mouseDragElement.visible):
		$Canvas/mouseDragElement.rect_position = get_local_mouse_position()
		if(isMouseInEditor()):
			$Canvas/mouseDragElement.modulate.a = 1.0
		else:
			$Canvas/mouseDragElement.modulate.a = 0.5

# prevent scrolling
func _on_window_size_changed():
	$preview.scroll_offset = Vector2(0, 0)
