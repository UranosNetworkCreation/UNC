#ifndef EDITOR_H_UNC_KERNEL
#define EDITOR_H_UNC_KERNEL

#include "Godot.hpp"
#include "Control.hpp"
#include "../PluginLoader/PluginLoader.h"

namespace godot {
    class Editor : public Control
    {
    GODOT_CLASS(Editor, Control)
    private:
        PluginLoader* KLoaderInst;
    public:
        static void _register_methods();
        void _ready();
        Editor();
        ~Editor();
    };
}

#endif