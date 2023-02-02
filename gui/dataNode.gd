extends GraphNode

# Preload Resource Syncronizer
const ResDataSync = preload("ResDataSync.gd")
# Preload node data resource
const NodeData = preload("res://kernel/resources/node.gd")

# ResDataSync instance
var DataSync : ResDataSync

var packedPath : String = "<None>"

func init_as_node(packedPth):
	# Assign values to vars
	packedPath = packedPth

# Returns the user settings from the node as a NodeData resource
func getNodeData() -> NodeData:
	# Create a new Data container
	var data : NodeData = NodeData.new()

	# collect node's data
	data.data = DataSync.collectData()
	data.offset = self.offset
	data.type = self.packedPath
	data.name = self.name

	return data

func _ready():
	DataSync = ResDataSync.new(self)
