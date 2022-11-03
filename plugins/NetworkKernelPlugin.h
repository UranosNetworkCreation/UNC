#ifndef NETWORK_KERNEL_PLUGIN_H_URANOSNETWORKCREATION
#define NETWORK_KERNEL_PLUGIN_H_URANOSNETWORKCREATION

#include <Godot.hpp>
#include <String.hpp>
#include <Array.hpp>

#define STR_VAL_NONE "None"

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

    class NetworkKernelPlugin : public godot::Object
    {
    GODOT_CLASS(NetworkKernelPlugin, godot::Object)
    public:
        virtual NetworkKernelPluginInfo getInfo() {
            return NetworkKernelPluginInfo("Default", "None", "", "None");
        }

        Array getInfoArray() {
            return getInfo().getData();
        }

        static void _register_methods() {
            register_method("getInfo", &NetworkKernelPlugin::getInfoArray);
        }
    };
} // namespace godot

#endif