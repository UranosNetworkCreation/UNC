extends Tabs

var TrainingSection : PackedScene = preload("Training/section.tscn")
var TrainingContainer

func _ready():
	TrainingContainer = get_node("ScrollContainer/VBoxContainer")


func _on_Add_pressed():
	TrainingContainer.add_child(TrainingSection.instance())
