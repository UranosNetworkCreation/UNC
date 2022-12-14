extends Node
# [Executer.gd]

class CalcTarget:
    const gNode = preload("res://gui/gNode.gd")

    var begin : gNode
    var end : gNode
    func _init(begin_node : GraphNode, end_node : GraphNode):
        self.begin = begin_node
        self.end = end_node

class TrainValuePair:
    var x : Array
    var y : Array
    func _init(nX : Array, nY : Array):
        self.x = nX
        self.y = nY

# signals for normal calculation
signal ExecuteSoftware
signal PrepareExecuting
signal ExecutingDone

# signals for backpropagation
signal BackpropRequest(target, values)
signal PrepareBackprop
signal Backprop(target, values)
signal BackpropDone(target, values)

var currentTrainValues : TrainValuePair = null
var currentTrainTargets : CalcTarget = null

func get_current_trainvalues() -> TrainValuePair:
    return currentTrainValues

func get_current_traintarget() -> CalcTarget:
    return currentTrainTargets

func exeCurrentLoaded():
    emit_signal("PrepareExecuting")
    emit_signal("ExecuteSoftware")
    emit_signal("ExecutingDone")

func backprop(target : CalcTarget, values : TrainValuePair):
    emit_signal("BackpropRequest", target, values)
    exeCurrentLoaded()

    currentTrainValues = values
    currentTrainTargets = target

    print("[Executer] Prepare backprop ...")
    emit_signal("PrepareBackprop")
    print("[Executer] backprop ...")
    emit_signal("Backprop", target, values)
    print("[Executer] Cleanup ...")
    emit_signal("BackpropDone", target, values)

    currentTrainValues = null
    currentTrainTargets = null