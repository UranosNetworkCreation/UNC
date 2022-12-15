extends WindowDialog

# preload ThemeCollection class
const ThemeCollection = preload("res://assets/themeCollection.gd")

# NodePaths (assign values in editor)
export var ThemeOptionButtonPath : NodePath
export var MainEditorPath : NodePath

# essencial nodes
var ThemeOBtn : OptionButton
var MainEditor : Control

# Loaded Theme collection
var TColl

func _ready():
	# Assign nodes to vars
	ThemeOBtn = get_node(ThemeOptionButtonPath)
	MainEditor = get_node(MainEditorPath)

	# Load ThemeCollection
	TColl = ResourceLoader.load("res://assets/themes/themes.tres") as ThemeCollection
	
	# Update OptionBtn and warning text
	for path in TColl.paths:
		ThemeOBtn.add_item(path.rsplit("/", false, 1)[1])
	set_theme_warning_enabled(false)

# Set the visibility of the warning text
func set_theme_warning_enabled(value : bool):
	if(value):
		$TabContainer/Display/GridContainer/ThemeOptionBtn/Label.show();
		$TabContainer/Display/GridContainer/ThemeLbl.rect_min_size.y = 50 + $TabContainer/Display/GridContainer/ThemeOptionBtn/Label.rect_size.y;
	else:
		$TabContainer/Display/GridContainer/ThemeOptionBtn/Label.hide();
		$TabContainer/Display/GridContainer/ThemeLbl.rect_min_size.y = 0;

func _on_ThemeOptionBtn_item_selected(index:int):
	# Load theme
	MainEditor.theme = ResourceLoader.load(TColl.paths[index])

	# Update warning label
	set_theme_warning_enabled(!TColl.optimized[index])
