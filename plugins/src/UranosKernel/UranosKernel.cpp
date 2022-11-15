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

void UranosKernel::_init() {

}

void UranosKernel::_register_methods() {
    register_method("_init", &UranosKernel::_init);
}