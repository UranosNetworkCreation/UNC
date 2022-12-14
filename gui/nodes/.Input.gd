extends "../gNode.gd"

func getEConn():
    return 0

func init_editor_controls():
    print(
        "[Input][", name, "] Connect  with Excecuter: ",
        Executer.connect("Backprop", self, "_on_backprop"), ", ",
        Executer.connect("BackpropRequest", self, "_on_backpropRequest")
    )

func _on_backpropRequest(target : Executer.CalcTarget, values : Executer.TrainValuePair):
    if(target.begin == self):
        DataSync.loadData(values.x)

func _on_backprop(target : Executer.CalcTarget, _values : Executer.TrainValuePair):
    if(target.begin == self):
        print("[Input][", name, "] Start backprop process ...")
        getDataOfPinConn(getEConn(), true)