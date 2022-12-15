#include "UranosKernel.h"
#include <string>
#include <sstream>

using namespace godot;

NetworkKernelPluginInfo UranosKernel::getInfo() {
    return NetworkKernelPluginInfo(
        "UranosKernel",         // name
        "0.0.1",                // version
        "Apilonius64",          // author
        "Default network kernel"// description
    );
}

// GD-Constructur
void UranosKernel::_init() {

}

void UranosKernel::_register_methods() {
    // Register GD constructur
    register_method("_init", &UranosKernel::_init);
}

void UranosKernel::Layer::build(size_t n_size, size_t parent_size, int64_t seed)  {
    size = n_size;

    // Create rng
    Ref<RandomNumberGenerator> rnd = RandomNumberGenerator::_new();

    // Create empty weights array
    Array Nweights = Array();

    // Init rng
    if(seed == -1) {
        Godot::print("   | prepare pseudo-rnd: randomize seed ...");
        rnd->randomize();
    }
    else {
        Godot::print("   | prepare pseudo-rnd: set seed ...");
        rnd->set_seed(seed);
    }
    
    // Randomize weights
    for(size_t i = 0; i < size;i++) {
        PoolRealArray randomizedArr;
        std::stringstream msg;
#ifdef UNC_EXTENDED_DEBUG
        msg << "   | Gen weights for neuron " << i << " ...";
        Godot::print(msg.str().c_str());
#endif
        for(size_t ci = 0; ci < parent_size; ci++) {
            randomizedArr.push_back(rnd->randf());
        }

#ifdef UNC_EXTENDED_DEBUG
        Godot::print(ArrayToStr<PoolRealArray>(randomizedArr, randomizedArr.size()));
#endif
        Nweights.push_back(randomizedArr);
    }

    // Build Layer
    buildFromWeights(Nweights, n_size, parent_size);
}

void UranosKernel::Layer::buildFromWeights(Array n_weights, size_t n_size, size_t parent_size) {
    Godot::print(" | Build Layer ...");
    // Update vars
    weights = n_weights;
    size = n_size;
    parentSz = parent_size;
}

PoolRealArray UranosKernel::Layer::getResult(NeuronActivationFunc activation_func, PoolRealArray input) {
    // Update lastInput
    lastInput = input;

    // Create result array
    PoolRealArray result;

    // Do activation_func(wi * conn, ...) for each neuron
    for(int i=0;i<size;i++) {
        float neuronInputValue = 0;
#ifdef UNC_EXTENDED_DEBUG
        Godot::print("[UNC-Kernel] Calc neuron " + STR(i));
#endif
        for(int ci=0;ci<parentSz;ci++) {
            real_t value = ((PoolRealArray)(weights[i]))[ci] * input[ci];
#ifdef UNC_EXTENDED_DEBUG
            Godot::print(" | Add value " + STR(value));
#endif
            neuronInputValue += value;
        }

#ifdef UNC_EXTENDED_DEBUG
        Godot::print(" | Calc activation func for " + STR(neuronInputValue));
#endif
        result.append(activation_func(neuronInputValue));
    }

    // Update lastresult
    lastResult = result;

    return result;
}

PoolRealArray UranosKernel::Layer::backprop(
    PoolRealArray under_grad,
    Array under_weights,
    NeuronActivationFunc derivative,
    bool outputLayer,
    real_t learning_rate
) {
    // Create empty array for the gradient
    PoolRealArray gradient;
    // Check if it's an oututLayer
    if(!outputLayer) {
#ifdef UNC_EXTENDED_DEBUG
        Godot::print(" | Using algorithm for hidden layer ...");
#endif
        // Calculate the gradient foreach neuron
        for (int idx = 0; idx < size; idx++) {
            real_t sum = 0;
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("  | Calc gradient for idx " + STR(idx));
#endif
            // ci = connection index
            for(int ci = 0; ci < under_weights.size(); ci++) {
#ifdef UNC_EXTENDED_DEBUG
                Godot::print("  | Update sum for idx " + STR(ci));
#endif
                // Add to sum
                sum += ((PoolRealArray)under_weights[ci])[idx] * under_grad[ci];                                                                             
            }

            // push back calculated result
            gradient.push_back(sum * derivative(lastResult[idx]));
        }
    }
    else {
#ifdef UNC_EXTENDED_DEBUG
        Godot::print(" | Using algorithm for output layer ...");
#endif
        // Calculate th egradient foreach neuron
        for (int idx = 0; idx < size; idx++) {
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("  | Calc gradient for idx " + STR(idx));
#endif
            // push the calculated result back
            gradient.push_back((lastResult[idx] - under_grad[idx]) * derivative(lastResult[idx]));
        }
    }

#ifdef UNC_EXTENDED_DEBUG
    Godot::print(" | Update weights ... ");
    Godot::print(" | Notice: size: " + STR(size) + ", parentSz: " + STR(parentSz) + ", gradientSize: " + STR(gradient.size()) + ", lastOutputSize: " + STR(lastResult.size()));
#endif

    // Update weights
    Array nWeights;
    for (int idx = 0; idx < size; idx++) {
        PoolRealArray connWeights;
        for(int i = 0; i < parentSz; i++) {
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | Calc new weight for " + STR(idx) + " | " + STR(i));
            Godot::print("   | lastInputV ...");
#endif
            // Get last input
            real_t lastInputV = lastInput[i];
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | gradientV ...");
#endif
            // Get gradient
            real_t gradientV = gradient[idx];
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | calc final ...");
#endif
            // Calculate nValue
            real_t nValue = ((PoolRealArray)weights[idx])[i] - (learning_rate * lastInputV * gradientV);
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | push ...");
#endif
            // push back to weights array
            connWeights.push_back(nValue);
        }

        // push back to new weights
        nWeights.push_back(connWeights);
    }
#ifdef UNC_EXTENDED_DEBUG
    Godot::print(" | Assign to weights array ...");
    Godot::print(" | Notice: Shape of nWeights: " + STR(nWeights.size()) + " | " + STR(((PoolRealArray)nWeights[0]).size()));
    Godot::print(" | Notice: Shape of weights: " + STR(weights.size()) + " | " + STR(((PoolRealArray)weights[0]).size()));
#endif
    // Update weights
    weights = nWeights;

#ifdef UNC_EXTENDED_DEBUG
    Godot::print(" | weights updated.");
    Godot::print(" | Notice: Shape of weights: " + STR(weights.size()) + " | " + STR(((PoolRealArray)weights[0]).size()));
#endif
    // return the gradient
    return gradient;
}

Array UranosKernel::Layer::getWeights() {
    return weights;
}

int UranosKernel::buildLayer(
    int size,
    int parent_size,
    Array weights
) {
    Godot::print("[UNC-Kernel] Build Layer ...");
    // Create the Layer
    Layer result;

    // Check if weights are given
    if(!weights.empty()) {
        Godot::print("| Build from weights ...");
        // Build Layer
        result.buildFromWeights(weights, size, parent_size);
    }
    else {
        Godot::print("| Gen weights ...");
        // Build Layer
        result.build(size, parent_size);
    }

    // push back to Layer-Array
    int idx = Layers.size();
    Layers.push_back(result);

    return idx;
}

// feeds forward
PoolRealArray UranosKernel::SimpleLayerCall(
    int id,
    PoolRealArray input,
    int activationFunc
) {
#ifdef UNC_EXTENDED_DEBUG
    Godot::print("[UranosKernel] Simple layer call for Layer with index " + STR(id));
#endif
    NeuronActivationFunc aFunc;

    // Set the activation func
    switch (activationFunc)
    {
    case ACTIVATION_FUNC_SIGMOID:
        aFunc = &UranosKernel::AFuncs::sigmoid;
        break;
    
    default:
        Godot::print("[UranosKernel] No Support for selected activation func. Use sigmoid as default ...");
        aFunc = &UranosKernel::AFuncs::sigmoid;
        break;
    }

    // Call the Layer and return the result
    return Layers[id].getResult(aFunc, input);
}

PoolRealArray UranosKernel::BackpropLayer(
    int id,
    PoolRealArray underGrad,
    Array underWeights,
    int activationFunc,
    bool outputLayer,
    real_t learning_rate
) {
#ifdef UNC_EXTENDED_DEBUG
    Godot::print("[UranosKernel] Backprop Layer ...");
#endif
    NeuronActivationFunc ADerivative;

    // Set the activation func
    switch (activationFunc)
    {
    case ACTIVATION_FUNC_SIGMOID:
        ADerivative = &UranosKernel::AFuncs::sigmoid_derivative;
        break;
    
    default:
        Godot::print("[UranosKernel] No Support for selected activation func. Use the derivative of sigmoid as default ...");
        ADerivative = &UranosKernel::AFuncs::sigmoid_derivative;
        break;
    }

    // Call the Layer and return the result
    return Layers[id].backprop(underGrad, underWeights, ADerivative, outputLayer, learning_rate);
}

Array UranosKernel::getLayerWeights(
    int id
) {
    // Call the Layer and return the result
    return Layers[id].getWeights();
}