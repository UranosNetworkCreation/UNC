extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var pixel = null
signal scene_loaded
var GEdit : GraphEdit

const UNCFile = preload("resources/unc.gd")
const NodeData = preload("resources/node.gd")
const GraphData = preload("resources/graphData.gd")


# Called when the node enters the scene tree for the first time.
func _ready():
	GEdit = get_node("HSplitContainer/HSplitContainer/GraphEdit")
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

func _on_run_pressed():
	Executer.exeCurrentLoaded()

func file_new():
	pass

func save_current(path) -> int:
	var file : UNCFile = UNCFile.new()
	file.GData = GEdit.getData()
	return ResourceSaver.save(path, file)

func resetEditor():
	GEdit.reset()

func open_file(path) -> int:
	var file = ResourceLoader.load(path)
	if(!(file is UNCFile)):
		print("Cannot load file because it's not an UNCFile")
		return -1
	
	resetEditor()
	print("[Editor] Load gEdit data ...")
	GEdit.loadData(file.GData)
	return 0
