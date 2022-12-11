#ifndef NETWORK_KERNEL_PLUGIN_H_URANOSNETWORKCREATION
#define NETWORK_KERNEL_PLUGIN_H_URANOSNETWORKCREATION

#include <Godot.hpp>
#include <String.hpp>
#include <Array.hpp>
#include <PoolArrays.hpp>
#include <RandomNumberGenerator.hpp>
#include <FuncRef.hpp>

#define STR_VAL_NONE "None"

#define STR(_X) String(std::to_string(_X).c_str())

namespace godot
{
    class GDDataContainer : public godot::Object {
    GODOT_CLASS(GDDataContainer, godot::Object)
    public:
        virtual Array getData() {
            return Array();
        }

        static void _register_methods() {

        }
    };

    class NetworkKernelPluginInfo : public GDDataContainer {
        GODOT_CLASS(NetworkKernelPluginInfo, GDDataContainer)
    public:
        String name;
        String version;
        String author;
        String description;

        NetworkKernelPluginInfo() {
            NetworkKernelPluginInfo(STR_VAL_NONE, STR_VAL_NONE, STR_VAL_NONE, STR_VAL_NONE);
        }

        NetworkKernelPluginInfo(
            String nName,
            String nVersion,
            String nAuthor,
            String nDescription
        ) {
            name = nName;
            version = nVersion;
            author = nAuthor;
            description = nDescription;
        }

        Array getData() override {
            Array dataArr;
            dataArr.push_back(name);
            dataArr.push_back(version);
            dataArr.push_back(author);
            dataArr.push_back(description);

            return dataArr;
        }

        static void _register_methods() {
            register_method("getData", &NetworkKernelPluginInfo::getData);
        }
    };

    constexpr int ACTIVATION_FUNC_SIGMOID = 0;

    class NetworkKernelPlugin : public godot::Object
    {
    GODOT_CLASS(NetworkKernelPlugin, godot::Object)
    public:
        template <typename T>
        static String ArrayToStr(T array, int size) {
            std::string temp_result = "[";
            for(int i=0;i<size;i++) {
                temp_result += std::to_string(array[i]);
                if(i < (size-1)) {
                    temp_result += ",";
                }
            }

            temp_result += "]";

            return String(temp_result.c_str());
        }

        virtual NetworkKernelPluginInfo getInfo() {
            return NetworkKernelPluginInfo("Default", "None", "", "None");
        }

        Array getInfoArray() {
            Godot::print("Get info array ...");
            return getInfo().getData();
        }

        static void _register_methods() {
            register_method("getInfo", &NetworkKernelPlugin::getInfoArray);
            register_method("simple_layer_call", &NetworkKernelPlugin::SimpleLayerCall);
            register_method("build_layer", &NetworkKernelPlugin::buildLayer);
            register_method("backprop_layer", &NetworkKernelPlugin::BackpropLayer);
            register_method("get_layer_weights", &NetworkKernelPlugin::getLayerWeights);
        }

        virtual int buildLayer(int size, int parent_size, Array weights) {
            return -1;
        }

        virtual PoolRealArray BackpropLayer(
            int id,
            PoolRealArray underGrad,
            Array underWeights,
            int activationFunc,
            bool outputLayer = false,
            real_t learning_rate = 0.2
        ) {
            return PoolRealArray();
        }

        virtual PoolRealArray SimpleLayerCall(
            int id,
            PoolRealArray input,
            int activationFunc
        ) {
            return PoolRealArray();
        }

        virtual Array getLayerWeights(
            int id
        ) {
            return Array();
        }
    };
} // namespace godot

#endif