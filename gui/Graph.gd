extends GraphEdit

const GraphData = preload("res://kernel/resources/graphData.gd")
const NodeData = preload("res://kernel/resources/node.gd")

func _ready():
	pass


func _on_GraphEdit_connection_request(from:String, from_slot:int, to:String, to_slot:int):
	for con in get_connection_list():
		if con.to == to and con.to_port == to_slot:
			print("[Graph] Exit from connection request process. Warning: You can't double connect nodes")
			return
	print("[Graph] Connect nodes(from: ", from, ", from_slot: ", from_slot, ", to: ", to, ", to_slot: ", to_slot, "): ", connect_node(from, from_slot, to, to_slot))


func _on_GraphEdit_delete_nodes_request(nodes:Array):
	print("[GraphEdit] Del nodes ...")
	for node in nodes:
		print("[GraphEdit] Del node " + node)
		remove_connections_to_node(node)
		get_node(node).queue_free()

func remove_connections_to_node(node_path):
	var node = get_node(node_path)
	for conn in get_connection_list():
		if conn.to == node.name or conn.from == node.name:
			disconnect_node(conn.from, conn.from_port, conn.to, conn.to_port)

func getData() -> GraphData:
	var gData : GraphData = GraphData.new()

	for child in get_children():
		if child is GraphNode:
			print("[Editor][Save] Collect node data ...")
			gData.nodes.append(child.getNodeData())

	gData.conns = get_connection_list()
	return gData

func updateConnectionNodeName(var old : String, var new : String, var conns : Array) -> Array:
	var result : Array = []
	for conn in conns:
		var nconn = conn
		if(nconn.from == old):
			nconn.from = new
		if(nconn.to == old):
			nconn.to = new
		result.append(nconn)
	return result

func loadData(var data : GraphData):
	for node in data.nodes:
		print("[Editor][OpenFile] Creating node with type: " + node.type)
		var nodeInst = load(node.type).instance()
		nodeInst.offset = node.offset
		nodeInst.name = node.name
		add_child(nodeInst)
		nodeInst.init_as_node(node.type)
		nodeInst.DataSync.loadData(node.data)
		data.conns = updateConnectionNodeName(node.name, nodeInst.name, data.conns)

	for conn in data.conns:
		print("[Editor][OpenFile] Conn nodes: ", connect_node(conn.from, conn.from_port, conn.to, conn.to_port))

func reset():
	print("[GEdit] resetting  ...")
	clear_connections()
	for child in get_children():
		if child is GraphNode:
			child.queue_free()
			remove_child(child)
