extends TabContainer

# Instances
var DirInst : Directory
# presets
var baseTab = preload("res://gui/nodesContainer/baseTab.tscn")
var basePreview = preload("res://gui/nodesContainer/preview.tscn")
# other vars
var result

func _ready():
	# Init dirInst
	DirInst = Directory.new()
	result = DirInst.open("res://gui/nodes/")
	result = DirInst.list_dir_begin()

	# Add nodes to sidebar
	while(true):
		# get next file
		var file = DirInst.get_next()
		if(file == ""):
			# exit if there is no file left
			break
		elif(!file.begins_with(".")):
			# Create a new tab from the preset
			var newTab = baseTab.instance()
			newTab.name = file.get_basename()
			add_child(newTab)

			# Get the preview container
			var pContainer = newTab.getNodeContainer()
			# Create the preview
			var nPreview = basePreview.instance()
			nPreview.setGEditor(get_node("../../HSplitContainer/GraphEdit"))
			pContainer.add_child(nPreview)

			# Create an additional Directory instance
			var FolderScanner = Directory.new()
			FolderScanner.open("res://gui/nodes/" + file.get_basename())
			FolderScanner.list_dir_begin()

			# node offset
			var OffsetY = 10
			while(true):
				# get next file
				var Nfile = FolderScanner.get_next()
				if(Nfile == ""):
					break
				elif(!Nfile.begins_with(".")):
					# Create the node path
					var lNodePath = "res://gui/nodes/" + file.get_basename() + "/" + Nfile
					print("[NodesContainer] Load \"" + lNodePath + "\".")

					# Load preset
					var lNode = load(lNodePath) as PackedScene
					# Create instance
					var lNodeInst = lNode.instance() as GraphNode
					lNodeInst.show_close = false
					lNodeInst.set_size(Vector2(180, lNodeInst.get_rect().size.y))
					lNodeInst.offset.x = 22
					lNodeInst.offset.y = OffsetY
					nPreview.addNode(lNodeInst, lNodePath)
					# set offset
					OffsetY += lNodeInst.get_rect().size.y + 10
					print("[NodesContainer] Loading done.")