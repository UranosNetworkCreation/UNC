#include "PluginLoader.h"
#include <NativeScript.hpp>
#include <Ref.hpp>
#include <Variant.hpp>

using namespace godot;

PluginLoader::PluginLoader() {
    // Init member vars
    DirectoryInst = new Directory();

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
    DirectoryInst->open("res://gdns/plugins/");
    DirectoryInst->list_dir_begin();

    while(true) {
        // Get current file str
        String file = DirectoryInst->get_next();

        // Exit if all files are processed
        if(file == "") {
            break;
        }

        // Only "non-hidden" progress files
        else if(!file.begins_with(".")) {
            // Load Script
            Ref<NativeScript> plugin = ResLInst->load("res://gdns/plugins/" + file);
            plugins.push_back(plugin->new_());
        }
    }
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