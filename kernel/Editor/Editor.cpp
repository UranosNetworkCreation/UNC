#include "Editor.h"

#include <iostream>

using namespace godot;

void Editor::_register_methods() {
    register_method("_ready", Editor::_ready);
}

void Editor::_ready() {
    KLoaderInst = get_node<PluginLoader>("/root/PluginLoader");
    std::vector<NetworkKernelPluginInfo> PluginOverview = KLoaderInst->getAllPluginsInfo();
    
    for(std::vector<NetworkKernelPluginInfo>::iterator it = PluginOverview.begin(); it != PluginOverview.end(); ++it) {
        Godot::print(it->name);
    }
}