#include "UranosKernel.h"

using namespace godot;

NetworkKernelPluginInfo UranosKernel::getInfo() {
    return NetworkKernelPluginInfo(
        "UranosKernel",
        "0.0.1",
        "Apilonius64",
        "Default network kernel"
    );
}