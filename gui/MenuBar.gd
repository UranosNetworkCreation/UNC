extends Panel

export var SettingsDialogPath : NodePath
export var SaveAsDialogPath : NodePath
export var FileOpenDialogPath : NodePath
export var EditorPath : NodePath
export var MsgPath : NodePath

var SettingsDialog : Popup
var SaveAsDialog : Popup
var FileOpenDialog : Popup
var Msg : Label

var MainEditor

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

var currentPath : String

# Called when the node enters the scene tree for the first time.
func _ready():
	currentPath = ""

	FileMenuBtn = get_node("Left/File")
	NetworkMenuBtn = get_node("Left/Network")
	ViewMenuBtn = get_node("Left/View")
	EditMenuBtn = get_node("Left/Edit")
	HelpMenuBtn = get_node("Left/Help")

	SettingsDialog = get_node(SettingsDialogPath)
	SaveAsDialog = get_node(SaveAsDialogPath)
	FileOpenDialog = get_node(FileOpenDialogPath)
	MainEditor = get_node(EditorPath)
	Msg = get_node(MsgPath)

	print("[MenuBar] Connect with file btn: ", FileMenuBtn.get_popup().connect("id_pressed", self, "on_file_id_pressed"))
	print("[MenuBar] Connect with view btn: ", ViewMenuBtn.get_popup().connect("id_pressed", self, "on_view_id_pressed"))
	print("[MenuBar] Connect with edit btn: ", EditMenuBtn.get_popup().connect("id_pressed", self, "on_edit_id_pressed"))

func on_file_id_pressed(var idx : int):
	match(idx):
		FILE_NEW:
			MainEditor.resetEditor()
		FILE_OPEN:
			FileOpenDialog.popup_centered()
		FILE_SAVE:
			if(currentPath == ""):
				SaveAsDialog.popup_centered()
			else:
				MainEditor.save_current(currentPath)
				Msg.text = "File saved to \"" + currentPath + "\""
		FILE_SAVEAS:
			SaveAsDialog.popup_centered()

func on_view_id_pressed(var idx : int):
	match(idx):
		VIEW_TOGGLEFULLSCREEN:
			OS.window_fullscreen = !OS.window_fullscreen

func on_edit_id_pressed(var idx : int):
	match(idx):
		EDIT_SETTINGS:
			SettingsDialog.popup_centered()

func _on_SaveAs_file_selected(path:String):
	currentPath = path
	MainEditor.save_current(currentPath)
	Msg.text = "File saved to \"" + currentPath + "\""
	

func _on_OpenFile_file_selected(path:String):
	if(MainEditor.open_file(path) != -1):
		currentPath = path
		Msg.text = "File opened from \"" + currentPath + "\""
	else:
		Msg.text = "Cannot open file \"" + path + "\""
