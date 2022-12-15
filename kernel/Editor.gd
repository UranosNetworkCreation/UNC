extends Control

# vars
var pixel = null

# emitted when the splashscreen is done
signal scene_loaded

# GraphEditor
var GEdit : GraphEdit

# Resource presets for saving and loading files
const UNCFile = preload("resources/unc.gd")
const NodeData = preload("resources/node.gd")
const GraphData = preload("resources/graphData.gd")

func _ready():
	# Get Editor
	GEdit = get_node("HSplitContainer/HSplitContainer/GraphEdit")
	# Load plugins
	PluginLoader.loadPlugins()
	# Connect scene_loaded handle with signal
	print("[Editor] Connecting signal: ", connect("scene_loaded", self, "_on_scene_loaded"))


func _process(_delta):
	# Get viewport text
	var vtex = get_viewport().get_texture().get_data()
	#vtex.lock()
	# Get the first pixel
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
	# resize the window
	OS.set_window_size(Vector2(1200, 600))
	OS.window_borderless = false

	# maximize the window
	OS.center_window()
	OS.window_maximized = true

func _on_run_pressed():
	# Run current AI
	Executer.exeCurrentLoaded()

func file_new():
	pass

# saves the current state to the given path
func save_current(path) -> int:
	# Create a new file container
	var file : UNCFile = UNCFile.new()
	# Assign the GraphData
	file.GData = GEdit.getData()
	# Save the file
	return ResourceSaver.save(path, file)

# clears the full Editor
func resetEditor():
	GEdit.reset()

# opens the given file
func open_file(path) -> int:
	# Load file
	var file = ResourceLoader.load(path)
	# Check if the file is a UNCFile
	if(!(file is UNCFile)):
		print("Cannot load file because it's not an UNCFile")
		return -1
	
	# clear
	resetEditor()

	# Load data
	print("[Editor] Load gEdit data ...")
	GEdit.loadData(file.GData)
	return 0
