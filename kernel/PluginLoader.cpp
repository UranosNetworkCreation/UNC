#include "PluginLoader.h"
#include <NativeScript.hpp>
#include <Ref.hpp>
#include <Variant.hpp>

using namespace godot;

PluginLoader::PluginLoader() {
    Godot::print("[PluginLoader] Initalizing ...");
    // Init member vars
    DirectoryInst = Directory::_new();

    // Get global instances
    ResLInst    = ResourceLoader::get_singleton();
    OSInst      = OS            ::get_singleton();

    // Load plugins
    loadPlugins();
}

PluginLoader::~PluginLoader() {
    // clean up plugin array (-> "std::vector<NetworkKernelPlugin*> plugins")
    unloadPlugins();

    // clean up member vars
    delete DirectoryInst;
}

void PluginLoader::loadPlugins() {
    Godot::print("[PluginLoader] Load NNKernelPlugins ...");

    // Setup DirectoryInst
    Godot::print(" | Open folder ...");
    DirectoryInst->open("res://gdns/plugins/");
    Godot::print(" | Initalizing DirectoryInst ...");
    DirectoryInst->list_dir_begin();

    while(true) {
        Godot::print(" | Searching in dictionary ...");
        // Get current file str
        String file = DirectoryInst->get_next();

        Godot::print(" | File found: \"" + file + "\"");

        // Exit if all files are processed
        if(file == "") {
            break;
        }

        // Only "non-hidden" progress files
        else if(!file.begins_with(".")) {
            // Load Script
            Godot::print(" | Loading plugin ...");
            Ref<NativeScript> plugin = ResLInst->load("res://gdns/plugins/" + file);
            Godot::print(" | Instancing plugin ...");
            auto pluginInst = plugin->_new();
            if(NetworkKernelPlugin* kernelPlugin = (NetworkKernelPlugin*)pluginInst) {
                Godot::print(" | Stor Inst ...");
                plugins.push_back(kernelPlugin);
            }
        }
        else {
            Godot::print(" | Loading cancelled because file begins with \".\".");
        }
    }

    Godot::print("[PluginLoader] All NNKernelPlugins loaded.");
}

void PluginLoader::unloadPlugins() {
    // ..
}

std::vector<NetworkKernelPluginInfo> PluginLoader::getAllPluginsInfo() {
    // Container for result
    std::vector<NetworkKernelPluginInfo> result;

    // Iterate over plugins
    for(std::vector<NetworkKernelPlugin*>::iterator it = plugins.begin(); it != plugins.end(); ++it) {
        result.push_back((*it)->getInfo());
    }

    return result;
}

void PluginLoader::_register_methods() {
    
}