extends GraphEdit

# Preload resource types
const GraphData = preload("res://kernel/resources/graphData.gd")
const NodeData = preload("res://kernel/resources/node.gd")

func _on_GraphEdit_connection_request(from:String, from_slot:int, to:String, to_slot:int):
	# Check if nodes are already connected
	for con in get_connection_list():
		if con.to == to and con.to_port == to_slot:
			print("[Graph] Exit from connection request process. Warning: You can't double connect nodes")
			return

	# Connect nodes
	print("[Graph] Connect nodes(from: ", from, ", from_slot: ", from_slot, ", to: ", to, ", to_slot: ", to_slot, "): ", connect_node(from, from_slot, to, to_slot))


func _on_GraphEdit_delete_nodes_request(nodes:Array):
	print("[GraphEdit] Del nodes ...")
	for node in nodes:
		print("[GraphEdit] Del node " + node)
		# remove connections
		remove_connections_to_node(node)
		# delete node
		get_node(node).queue_free()

func remove_connections_to_node(node_path):
	# get node
	var node = get_node(node_path)
	for conn in get_connection_list():
		# check if the connection belongs to the node
		if conn.to == node.name or conn.from == node.name:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)

# Returns the current GraphData as a GraphData resource
func getData() -> GraphData:
	# Create new GraphData container
	var gData : GraphData = GraphData.new()

	# For each block ...
	for child in get_children():
		if child is GraphNode:
			print("[Editor][Save] Collect node data ...")
			# Append node specific data to container
			gData.nodes.append(child.getNodeData())

	# Add connection to data
	gData.conns = get_connection_list()
	return gData

# Update the name of a node in the connections array
func updateConnectionNodeName(var old : String, var new : String, var conns : Array) -> Array:
	# Create an emty array for the result
	var result : Array = []
	for conn in conns:
		var nconn = conn
		# Rename node in new conn
		if(nconn.from == old):
			nconn.from = new
		if(nconn.to == old):
			nconn.to = new

		# Add it to the result
		result.append(nconn)
	return result

# Loads the data from a GraphData resource
func loadData(var data : GraphData):
	# Load nodes
	for node in data.nodes:
		print("[Editor][OpenFile] Creating node with type: " + node.type)
		# Create node inst
		var nodeInst = load(node.type).instance()
		nodeInst.offset = node.offset
		nodeInst.name = node.name

		# Add node inst to Graph
		add_child(nodeInst)
		# Init inst and load data
		nodeInst.init_as_node(node.type)
		nodeInst.DataSync.loadData(node.data)
		# Update connections array
		data.conns = updateConnectionNodeName(node.name, nodeInst.name, data.conns)

	# Load connections
	for conn in data.conns:
		# connect nodes
		print("[Editor][OpenFile] Conn nodes: ", connect_node(conn.from, conn.from_port, conn.to, conn.to_port))

# Clear graph
func reset():
	print("[GEdit] resetting  ...")
	# delete all connections
	clear_connections()
	# delete all childs which are GraphNodes
	for child in get_children():
		if child is GraphNode:
			child.queue_free()
			remove_child(child)
