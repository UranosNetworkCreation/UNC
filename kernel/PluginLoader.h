#ifndef PLUGINLOADER_H_UNC_KERNEL
#define PLUGINLOADER_H_UNC_KERNEL

#include <vector>
#include <Godot.hpp>
#include <Directory.hpp>
#include <Array.hpp>
#include <ResourceLoader.hpp>
#include <OS.hpp>
#include "../../plugins/NetworkKernelPlugin.h"

//NOTE: PLUGINLOADER MUST BE REGISTERED AS SINGLETON!!!

namespace godot {
    class PluginLoader : public godot::Object {
    GODOT_CLASS(PluginLoader, godot::Object)
    private:
        std::vector<NetworkKernelPlugin*> plugins;
        Directory* DirectoryInst;
        ResourceLoader* ResLInst;
        OS* OSInst;
    public:
        PluginLoader();
        ~PluginLoader();
        void loadPlugins();
        void unloadPlugins();
        std::vector<NetworkKernelPluginInfo> getAllPluginsInfo();

        static void _register_methods();
    };
}

#endif