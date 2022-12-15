#include "UranosKernel.h"

extern "C" void GDN_EXPORT godot_gdnative_init(godot_gdnative_init_options *o) {
    // Init GDNative API
    godot::Godot::gdnative_init(o);
}

extern "C" void GDN_EXPORT godot_gdnative_terminate(godot_gdnative_terminate_options *o) {
    // Cleanup
    godot::Godot::gdnative_terminate(o);
}

extern "C" void GDN_EXPORT godot_nativescript_init(void *handle) {
    // init nativescript
    godot::Godot::nativescript_init(handle);

    // register classes
    godot::register_class<godot::GDDataContainer>();
    godot::register_class<godot::NetworkKernelPluginInfo>();
    godot::register_class<godot::NetworkKernelPlugin>();
    godot::register_class<godot::UranosKernel>();
}