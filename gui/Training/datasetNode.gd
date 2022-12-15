extends GraphNode

# handles
func _on_close_request():
	queue_free()
