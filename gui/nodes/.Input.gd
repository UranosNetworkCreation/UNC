extends "../gNode.gd"

# Base class for all input nodes

# Returns the main connection (Will be triggered during the training process)
func getEConn():
    return 0

func init_editor_controls():
    # Connect funcs with Executer
    print(
        "[Input][", name, "] Connect  with Excecuter: ",
        Executer.connect("Backprop", self, "_on_backprop"), ", ",
        Executer.connect("BackpropRequest", self, "_on_backpropRequest")
    )

func _on_backpropRequest(target : Executer.CalcTarget, values : Executer.TrainValuePair):
    # Load data from dataset if self == begin
    if(target.begin == self):
        DataSync.loadData(values.x)

func _on_backprop(target : Executer.CalcTarget, _values : Executer.TrainValuePair):
    # Trigger backprop process if self is start node
    if(target.begin == self):
        print("[Input][", name, "] Start backprop process ...")
        getDataOfPinConn(getEConn(), true)