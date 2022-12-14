extends GraphNode

func _on_close_request():
	queue_free()
