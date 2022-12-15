extends Node

# instance of Directory
var DirInst : Directory

# Loaded plugins
var plugins = []

# Loads the plugins
func loadPlugins():
	# open plugin floder
	print("[PluginLoader] Open plugindir returned ", DirInst.open("res://plugins/gdns"))
	print("[PluginLoader] Listing dir returned ", DirInst.list_dir_begin())

	while(true):
		# get next file
		var file = DirInst.get_next()
		if(file == ""):
			# exit if file string is empty
			break
		elif(!file.begins_with(".")):
			# Load plugin
			var plugin = load("res://plugins/gdns/" + file)
			print("[PluginLoader] plugin: ", plugin)

			# Instance plugin
			var pluginRef = plugin.new()

			# Check if pluginInst is valid
			if(!pluginRef.has_method("getInfo")):
				print("[PluginLoader] Fatal error: plugin is invalid.")

			# Add to plugin array
			plugins.append(pluginRef)
			print("[PluginLoader] plugin ", pluginRef.getInfo(), " loaded.")


func _ready():
	# Init DirInst
	DirInst = Directory.new()

func getCurrentPlugin():
	# return first plugin
	return plugins[0]
