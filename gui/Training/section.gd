extends Panel

# essencial nodes
var DatasetEditor : WindowDialog
var BeginSelector
var EndSelector
var InvalidSelectionWarning
var Iterations : SpinBox

var TrainThread : Thread
var LoadingDialog : Popup

func _ready():
	# Assign nodes to vars
	DatasetEditor = get_node("DatasetEditor")
	BeginSelector = get_node("VBoxContainer/GridContainer/StartPointSelector")
	EndSelector = get_node("VBoxContainer/GridContainer/EndPointSelector")
	InvalidSelectionWarning = get_node("InvalidNodeWarning")
	Iterations = get_node("Panel/HBoxContainer/Iterations")
	LoadingDialog = get_node("../../../../../../../../LoadingDialog")
	
	TrainThread = Thread.new()

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
		
func train():
	LoadingDialog.set_info("Training network ...")
	LoadingDialog.call_deferred("popup_centered")
	# get datasets
	var datasets = DatasetEditor.getDataSets()
	var it_count = Iterations.value
	var loading_step = 100/it_count
	for _iteration in range(it_count):
		for dataset in datasets:
			# Create CalcTarget
			var target = Executer.CalcTarget.new(BeginSelector.getSelectedNode(), EndSelector.getSelectedNode())
			# Create TrainValuePair
			var values = Executer.TrainValuePair.new(dataset[0], dataset[1])
			# Start backprop process
			Executer.backprop(target, values)
			LoadingDialog.call_deferred("update_bar", _iteration * loading_step)
	LoadingDialog.call_deferred("hide")

func _on_train_pressed():
	TrainThread.wait_to_finish()
	TrainThread.start(self, "train")
