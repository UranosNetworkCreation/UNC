#ifndef URANOS_KERNEL_PLUGIN
#define URANOS_KERNEL_PLUGIN

#include <Godot.hpp>

#include "../NetworkKernelPlugin.h"

namespace godot
{
    class UranosKernel : public NetworkKernelPlugin {
        GODOT_CLASS(UranosKernel, NetworkKernelPlugin)
    public:
        NetworkKernelPluginInfo getInfo() override;
    };
} // namespace godot

#endif