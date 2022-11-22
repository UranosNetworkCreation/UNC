extends Panel

export var SettingsDialogPath : NodePath

var SettingsDialog : Popup

var FileMenuBtn : MenuButton
var NetworkMenuBtn : MenuButton
var ViewMenuBtn : MenuButton
var EditMenuBtn : MenuButton
var HelpMenuBtn : MenuButton

const VIEW_TOGGLEFULLSCREEN = 0

const EDIT_SETTINGS = 0

const FILE_NEW 		= 0
const FILE_OPEN 	= 1
const FILE_SAVE 	= 2
const FILE_SAVEAS 	= 3

# Called when the node enters the scene tree for the first time.
func _ready():
	FileMenuBtn = get_node("Left/File")
	NetworkMenuBtn = get_node("Left/Network")
	ViewMenuBtn = get_node("Left/View")
	EditMenuBtn = get_node("Left/Edit")
	HelpMenuBtn = get_node("Left/Help")

	SettingsDialog = get_node(SettingsDialogPath)

	print("[MenuBar] Connect with file btn: ", FileMenuBtn.get_popup().connect("id_pressed", self, "on_file_id_pressed"))
	print("[MenuBar] Connect with view btn: ", ViewMenuBtn.get_popup().connect("id_pressed", self, "on_view_id_pressed"))
	print("[MenuBar] Connect with edit btn: ", EditMenuBtn.get_popup().connect("id_pressed", self, "on_edit_id_pressed"))

func on_file_id_pressed(var idx : int):
	match(idx):
		FILE_NEW:
			pass
		FILE_OPEN:
			pass
		FILE_SAVE:
			pass
		FILE_SAVEAS:
			pass

func on_view_id_pressed(var idx : int):
	match(idx):
		VIEW_TOGGLEFULLSCREEN:
			OS.window_fullscreen = !OS.window_fullscreen

func on_edit_id_pressed(var idx : int):
	match(idx):
		EDIT_SETTINGS:
			SettingsDialog.popup_centered()