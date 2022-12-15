extends "output.gd"


# essencial nodes
var ImageTexControl : TextureRect

func _ready():
	# Assign nodes to vars
	ImageTexControl = get_node("TextureRect")


func set_value(value):
	# Create texture
	var imgTex = ImageTexture.new()
	imgTex.create_from_image(value)

	# Update TextureRect
	ImageTexControl.texture = imgTex