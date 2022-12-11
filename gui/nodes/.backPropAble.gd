extends "../gNode.gd"

var backPropCalculated = false
var backPropResults = []

func backProp():
    pass

func getBackPropValue(var id : int):
    if(!backPropCalculated):
        backProp()
        backPropCalculated = true
    return backPropResults[id]