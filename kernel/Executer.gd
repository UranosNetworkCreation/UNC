extends Node
signal ExecuteSoftware
signal PrepareExecuting
signal ExecutingDone

func _ready():
    pass

func exeCurrentLoaded():
    emit_signal("PrepareExecuting")
    emit_signal("ExecuteSoftware")
    emit_signal("ExecutingDone")