extends Popup

onready var Bar = $PanelContainer/VBoxContainer/HBoxContainer/ProgressBar
onready var Lbl = $PanelContainer/VBoxContainer/HBoxContainer/Label

export var info : String

func _ready():
	set_info(info)

func update_bar(val):
	Bar.value = val
	
func set_info(text):
	Lbl.text = text
