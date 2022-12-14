extends "../gNode.gd"

func backCalc():
    assert(Executer.get_current_traintarget().end == self, "traintarget != self, but value requested.")
    backCalcResults = Executer.get_current_trainvalues().y