extends WindowDialog


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var DirInst : Directory
var CurrentItem : int = -1
var nodes = []

# Called when the node enters the scene tree for the first time.
#func _ready():
#	DirInst = Directory.new()
#	DirInst.open("res://gui/nodes/")
#	DirInst.list_dir_begin()

#	while(true):
#		var file = DirInst.get_next()
#		if(file == ""):
#			break
#		elif(!file.begins_with(".")):
#			$ItemList.add_item(file.get_basename())
#			nodes.append(load("res://gui/nodes/" + file))


func _on_AddNodeDialog_about_to_show():
	if(CurrentItem == -1):
		$Button.disabled = true


func _on_ItemList_item_selected(index:int):
	CurrentItem = index
	$Button.disabled = false


func _on_Button_pressed():
	$"../GraphEdit".add_child(nodes[CurrentItem].instance())
	hide()