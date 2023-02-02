extends "../dataNode.gd"

func _ready():
	._ready()

# handles
func _on_close_request():
	queue_free()
