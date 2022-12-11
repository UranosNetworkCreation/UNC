#include "UranosKernel.h"
#include <string>
#include <sstream>

using namespace godot;

NetworkKernelPluginInfo UranosKernel::getInfo() {
    return NetworkKernelPluginInfo(
        "UranosKernel",
        "0.0.1",
        "Apilonius64",
        "Default network kernel"
    );
}

void UranosKernel::_init() {

}

void UranosKernel::_register_methods() {
    register_method("_init", &UranosKernel::_init);
}

void UranosKernel::Layer::build(size_t n_size, size_t parent_size, int64_t seed)  {
    size = n_size;
    Ref<RandomNumberGenerator> rnd = RandomNumberGenerator::_new();
    Array Nweights = Array();

    if(seed == -1) {
        Godot::print("   | prepare pseudo-rnd: randomize seed ...");
        rnd->randomize();
    }
    else {
        Godot::print("   | prepare pseudo-rnd: set seed ...");
        rnd->set_seed(seed);
    }
    
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
    buildFromWeights(Nweights, n_size, parent_size);
}

void UranosKernel::Layer::buildFromWeights(Array n_weights, size_t n_size, size_t parent_size) {
    Godot::print(" | Build Layer ...");
    weights = n_weights;
    size = n_size;
    parentSz = parent_size;
}

PoolRealArray UranosKernel::Layer::getResult(NeuronActivationFunc activation_func, PoolRealArray input) {
    lastInput = input;
    PoolRealArray result;
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
    PoolRealArray gradient;
    if(!outputLayer) {
#ifdef UNC_EXTENDED_DEBUG
        Godot::print(" | Using algorithm for hidden layer ...");
#endif
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
                sum += ((PoolRealArray)under_weights[ci])[idx] * under_grad[ci];                                                                             
            }

            gradient.push_back(sum * derivative(lastResult[idx]));
        }
    }
    else {
#ifdef UNC_EXTENDED_DEBUG
        Godot::print(" | Using algorithm for output layer ...");
#endif
        for (int idx = 0; idx < size; idx++) {
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("  | Calc gradient for idx " + STR(idx));
#endif
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
            // POSSIBLE WRONG
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | Calc new weight for " + STR(idx) + " | " + STR(i));
            Godot::print("   | lastInputV ...");
#endif
            real_t lastInputV = lastInput[i];
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | gradientV ...");
#endif
            real_t gradientV = gradient[idx];
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | calc final ...");
#endif
            real_t nValue = ((PoolRealArray)weights[idx])[i] - (learning_rate * lastInputV * gradientV);
#ifdef UNC_EXTENDED_DEBUG
            Godot::print("   | push ...");
#endif
            connWeights.push_back(nValue);
        }

        nWeights.push_back(connWeights);
    }
#ifdef UNC_EXTENDED_DEBUG
    Godot::print(" | Assign to weights array ...");
    Godot::print(" | Notice: Shape of nWeights: " + STR(nWeights.size()) + " | " + STR(((PoolRealArray)nWeights[0]).size()));
    Godot::print(" | Notice: Shape of weights: " + STR(weights.size()) + " | " + STR(((PoolRealArray)weights[0]).size()));
#endif
    weights = nWeights;

#ifdef UNC_EXTENDED_DEBUG
    Godot::print(" | weights updated.");
    Godot::print(" | Notice: Shape of weights: " + STR(weights.size()) + " | " + STR(((PoolRealArray)weights[0]).size()));
#endif
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
    Layer result;
    if(!weights.empty()) {
        Godot::print("| Build from weights ...");
        result.buildFromWeights(weights, size, parent_size);
    }
    else {
        Godot::print("| Gen weights ...");
        result.build(size, parent_size);
    }

    int idx = Layers.size();
    Layers.push_back(result);

    return idx;
}

PoolRealArray UranosKernel::SimpleLayerCall(
    int id,
    PoolRealArray input,
    int activationFunc
) {
#ifdef UNC_EXTENDED_DEBUG
    Godot::print("[UranosKernel] Simple layer call for Layer with index " + STR(id));
#endif
    NeuronActivationFunc aFunc;

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

    return Layers[id].backprop(underGrad, underWeights, ADerivative, outputLayer, learning_rate);
}

Array UranosKernel::getLayerWeights(
    int id
) {
    return Layers[id].getWeights();
}