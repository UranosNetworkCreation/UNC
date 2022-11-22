extends TabContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var DirInst : Directory
var baseTab = preload("res://gui/nodesContainer/baseTab.tscn")
var basePreview = preload("res://gui/nodesContainer/preview.tscn")
var result

# Called when the node enters the scene tree for the first time.
func _ready():
	DirInst = Directory.new()
	result = DirInst.open("res://gui/nodes/")
	result = DirInst.list_dir_begin()
	while(true):
		var file = DirInst.get_next()
		if(file == ""):
			break
		elif(!file.begins_with(".")):
			var newTab = baseTab.instance()
			newTab.name = file.get_basename()
			#var icon = load("res://gui/nodes/" + file.get_basename() + "/symbol.png")
			add_child(newTab)
			var pContainer = newTab.getNodeContainer()
			var nPreview = basePreview.instance()
			nPreview.setGEditor(get_node("../../HSplitContainer/GraphEdit"))
			pContainer.add_child(nPreview)
			var FolderScanner = Directory.new()
			FolderScanner.open("res://gui/nodes/" + file.get_basename())
			FolderScanner.list_dir_begin()
			var OffsetY = 10
			while(true):
				var Nfile = FolderScanner.get_next()
				if(Nfile == ""):
					break
				elif(!Nfile.begins_with(".")):
					var lNodePath = "res://gui/nodes/" + file.get_basename() + "/" + Nfile
					print("[NodesContainer] Load \"" + lNodePath + "\".")
					var lNode = load(lNodePath) as PackedScene
					var lNodeInst = lNode.instance() as GraphNode
					lNodeInst.show_close = false
					lNodeInst.set_size(Vector2(180, lNodeInst.get_rect().size.y))
					lNodeInst.offset.x = 22
					lNodeInst.offset.y = OffsetY
					nPreview.addNode(lNodeInst, lNode)
					OffsetY += lNodeInst.get_rect().size.y + 10
					#lNodeInst.set_position(Vector2(10, 10))
					print("[NodesContainer] Loading done.")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
