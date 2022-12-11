#ifndef URANOS_KERNEL_PLUGIN
#define URANOS_KERNEL_PLUGIN

#include <Godot.hpp>
#include <vector>
#include <math.h>
#include <string>

#include "../NetworkKernelPlugin.h"

//#define UNC_EXTENDED_DEBUG

namespace godot
{
    typedef real_t (*NeuronActivationFunc)(real_t value); 
    class UranosKernel : public NetworkKernelPlugin {
        GODOT_CLASS(UranosKernel, NetworkKernelPlugin)
    public:
        class AFuncs {
        public:
            static real_t sigmoid(real_t value) {
                real_t result = 1 / (1 + Math::exp(-value));
#ifdef UNC_EXTENDED_DEBUG
                Godot::print(" | Sigmoid result: " + STR(result));
#endif
                return result;
            }

            // Maybe not exact enough
            static real_t sigmoid_derivative(real_t value) {
                real_t result = value * (1 - value);
    #ifdef UNC_EXTENDED_DEBUG
                Godot::print(" | Sigmoid result: " + STR(result));
    #endif
                return result;
            }
        };

        class Layer {
        private:
            Array weights;
            size_t size;
            size_t parentSz;
            PoolRealArray lastResult;
            PoolRealArray lastInput;
        public:
            void buildFromWeights(Array n_weights, size_t n_size, size_t parent_size);
            void build(size_t n_size, size_t parent_size, int64_t seed = -1);
            PoolRealArray getResult(NeuronActivationFunc activation, PoolRealArray input);
            // Returns the gradient
            PoolRealArray backprop(
                PoolRealArray under_grad,
                Array under_weights,
                NeuronActivationFunc derivative,
                bool outputLayer,
                real_t learning_rate
            );
            Array getWeights();
        };

        std::vector<Layer> Layers;

        static void _register_methods();
        void _init();
        NetworkKernelPluginInfo getInfo() override;

        int buildLayer(
            int size,
            int parent_size,
            Array weights
        ) override;

        PoolRealArray SimpleLayerCall(
            int id,
            PoolRealArray input,
            int activationFunc
        ) override;

        PoolRealArray BackpropLayer(
            int id,
            PoolRealArray underGrad,
            Array underWeights,
            int activationFunc,
            bool outputLayer = false,
            real_t learning_rate = 0.2
        ) override;

        Array getLayerWeights(
            int id
        ) override;
    };
} // namespace godot

#endif