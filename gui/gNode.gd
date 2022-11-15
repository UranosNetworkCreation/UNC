extends GraphNode


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var phantomInput
var preview
var packed : PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	print("[gNode] Connect signal: ", connect("close_request", self, "_on_close"))


func _on_close():
	queue_free()

func init_as_preview(phantomID, previewInst, packedScene):
	phantomInput = phantomID
	packed = packedScene
	preview = previewInst
	phantomInput.connect("button_down", self, "_on_grap")

func _on_grap():
	print(self, " grabed.")
	preview.begin_grabbing_node(self)
