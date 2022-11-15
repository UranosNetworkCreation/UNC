extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pixel = null
signal scene_loaded


# Called when the node enters the scene tree for the first time.
func _ready():
	PluginLoader.loadPlugins()
	print("[Editor] Connecting signal: ", connect("scene_loaded", self, "_on_scene_loaded"))


func _process(_delta):
	var vtex = get_viewport().get_texture().get_data()
	#vtex.lock()
	var currentPixel = vtex.get_pixel(0, 0)
	#vtex.unlock()
	if(pixel == null):
		pixel = currentPixel
	elif(pixel == currentPixel):
		emit_signal("scene_loaded")
		#OS.call_deferred("set", "window_size", Vector2(1200, 600))
		#OS.call_deferred("set", "window_borderless", false)
		#OS.call_deferred("center_window")
		set_process(false)

func _on_scene_loaded():
	OS.set_window_size(Vector2(1200, 600))
	OS.window_borderless = false
	OS.center_window()
	OS.window_maximized = true