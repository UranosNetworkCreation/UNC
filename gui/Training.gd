extends Tabs

# Preload section preset
var TrainingSection : PackedScene = preload("Training/section.tscn")

# Essencial nodes
var TrainingContainer

func _ready():
	# Assign nodes to vars
	TrainingContainer = get_node("ScrollContainer/VBoxContainer")

func _on_Add_pressed():
	# Create a new section
	TrainingContainer.add_child(TrainingSection.instance())
