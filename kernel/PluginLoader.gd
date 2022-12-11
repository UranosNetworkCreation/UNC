extends Node

var DirInst : Directory
var plugins = []

func loadPlugins():
	print("[PluginLoader] Open plugindir returned ", DirInst.open("res://plugins/gdns"))
	print("[PluginLoader] Listing dir returned ", DirInst.list_dir_begin())

	while(true):
		var file = DirInst.get_next()
		if(file == ""):
			break
		elif(!file.begins_with(".")):
			var plugin = load("res://plugins/gdns/" + file)
			print("[PluginLoader] plugin: ", plugin)
			var pluginRef = plugin.new()
			if(!pluginRef.has_method("getInfo")):
				print("[PluginLoader] Fatal error: plugin is invalid.")
			plugins.append(pluginRef)
			print("[PluginLoader] plugin ", pluginRef.getInfo(), " loaded.")


func _ready():
	DirInst = Directory.new()

func getCurrentPlugin():
	return plugins[0]
