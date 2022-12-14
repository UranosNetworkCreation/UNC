extends Panel

var DatasetEditor : WindowDialog
var BeginSelector
var EndSelector
var InvalidSelectionWarning
var Iterations : SpinBox

func _ready():
	DatasetEditor = get_node("DatasetEditor")
	BeginSelector = get_node("VBoxContainer/GridContainer/StartPointSelector")
	EndSelector = get_node("VBoxContainer/GridContainer/EndPointSelector")
	InvalidSelectionWarning = get_node("InvalidNodeWarning")
	Iterations = get_node("Panel/HBoxContainer/Iterations")

func _on_delete_pressed():
	queue_free()

func _on_EditData_pressed():
	if(!(BeginSelector.is_gNodevalid() && EndSelector.is_gNodevalid())):
		InvalidSelectionWarning.popup_centered()
	else:
		DatasetEditor.rect_size = get_viewport_rect().size
		DatasetEditor.popup_centered()

func _on_train_pressed():
	var datasets = DatasetEditor.getDataSets()
	for _iteration in range(Iterations.value):
		for dataset in datasets:
			var target = Executer.CalcTarget.new(BeginSelector.getSelectedNode(), EndSelector.getSelectedNode())
			var values = Executer.TrainValuePair.new(dataset[0], dataset[1])
			Executer.backprop(target, values)
