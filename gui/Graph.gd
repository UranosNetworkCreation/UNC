extends GraphEdit


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


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
	for con in get_connection_list():
		if con.to == node.name or con.from == node.name:
			disconnect_node(con.from, con.from_port, con.to, con.to_port)
