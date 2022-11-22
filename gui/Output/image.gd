extends "output.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var ImageTexControl : TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	ImageTexControl = get_node("TextureRect")


func set_value(value):
	var imgTex = ImageTexture.new()
	imgTex.create_from_image(value)

	ImageTexControl.texture = imgTex