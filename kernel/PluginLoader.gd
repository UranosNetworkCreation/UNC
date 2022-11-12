extends Node

var DirInst : Directory
var plugins = []

func loadPlugins():
	print("Open plugindir returned ", DirInst.open("res://gdns/plugins"))
	print("Listing dir returned ", DirInst.list_dir_begin())

	while(true):
		var file = DirInst.get_next()
		if(file == ""):
			break
		elif(!file.begins_with(".")):
			print("0")
			var plugin = load("res://gdns/plugins/" + file)
			print("plugin", plugin)
			print("3")
			var pluginRef = plugin.new()
			print("2")
			plugins.append(pluginRef)
			print("1")
			print("plugin", pluginRef.getInfo(), "loaded.")


func _ready():
	DirInst = Directory.new()

