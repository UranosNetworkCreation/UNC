extends "../gNode.gd"

# Base class for all outputs

# Calculation process during training
func backCalc():
    # Check if self is really the end point
    assert(Executer.get_current_traintarget().end == self, "traintarget != self, but value requested.")
    
    # Assign requested value to output array
    backCalcResults = Executer.get_current_trainvalues().y