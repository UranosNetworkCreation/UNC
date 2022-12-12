extends WindowDialog

const ThemeCollection = preload("res://assets/themeCollection.gd")

export var ThemeOptionButtonPath : NodePath
export var MainEditorPath : NodePath

var ThemeOBtn : OptionButton
var MainEditor : Control
var TColl

func _ready():
	ThemeOBtn = get_node(ThemeOptionButtonPath)
	MainEditor = get_node(MainEditorPath)

	TColl = ResourceLoader.load("res://assets/themes/themes.tres") as ThemeCollection
	for path in TColl.paths:
		ThemeOBtn.add_item(path.rsplit("/", false, 1)[1])
	set_theme_warning_enabled(false)

func set_theme_warning_enabled(value : bool):
	if(value):
		$TabContainer/Display/GridContainer/ThemeOptionBtn/Label.show();
		$TabContainer/Display/GridContainer/ThemeLbl.rect_min_size.y = 50 + $TabContainer/Display/GridContainer/ThemeOptionBtn/Label.rect_size.y;
	else:
		$TabContainer/Display/GridContainer/ThemeOptionBtn/Label.hide();
		$TabContainer/Display/GridContainer/ThemeLbl.rect_min_size.y = 0;

func _on_ThemeOptionBtn_item_selected(index:int):
	MainEditor.theme = ResourceLoader.load(TColl.paths[index])
	set_theme_warning_enabled(!TColl.optimized[index])
