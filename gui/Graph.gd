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
	#for con in get_node("GraphEdit").get_connection_list():
	#	if con.to == to and con.to_slot == to_slot:
	#		return
	connect_node(from, from_slot, to, to_slot)


func _on_GraphEdit_delete_nodes_request(nodes:Array):
	print("[GraphEdit] Del nodes ...")
	for node in nodes:
		print("[GraphEdit] Del node " + node)
		get_node(node).queue_free()
