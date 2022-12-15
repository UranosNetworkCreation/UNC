extends Panel

# essencial nodes
var DatasetEditor : WindowDialog
var BeginSelector
var EndSelector
var InvalidSelectionWarning
var Iterations : SpinBox

func _ready():
	# Assign nodes to vars
	DatasetEditor = get_node("DatasetEditor")
	BeginSelector = get_node("VBoxContainer/GridContainer/StartPointSelector")
	EndSelector = get_node("VBoxContainer/GridContainer/EndPointSelector")
	InvalidSelectionWarning = get_node("InvalidNodeWarning")
	Iterations = get_node("Panel/HBoxContainer/Iterations")

# handles
# -------
func _on_delete_pressed():
	queue_free()

func _on_EditData_pressed():
	# Check if selected nodes are valid
	if(!(BeginSelector.is_gNodevalid() && EndSelector.is_gNodevalid())):
		# Show warning
		InvalidSelectionWarning.popup_centered()
	else:
		# Open dataset editor
		DatasetEditor.rect_size = get_viewport_rect().size
		DatasetEditor.popup_centered()

func _on_train_pressed():
	# get datasets
	var datasets = DatasetEditor.getDataSets()
	for _iteration in range(Iterations.value):
		for dataset in datasets:
			# Create CalcTarget
			var target = Executer.CalcTarget.new(BeginSelector.getSelectedNode(), EndSelector.getSelectedNode())
			# Create TrainValuePair
			var values = Executer.TrainValuePair.new(dataset[0], dataset[1])
			# Start backprop process
			Executer.backprop(target, values)
