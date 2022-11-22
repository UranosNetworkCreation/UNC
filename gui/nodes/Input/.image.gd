extends "../../gNode.gd"


const OUTPUT_DATA2D = 0
const OUTPUT_SIZEX = 1
const OUTPUT_SIZEY = 2
const OUTPUT_FORMAT = 3
const OUTPUT_MIPMAP = 4

var PathInput
var ImagePreview : TextureRect


# Called when the node enters the scene tree for the first time.
func _ready():
	PathInput = get_node("LineEdit")
	ImagePreview = get_node("TextureRect")


func updateCalc():
	print("[gNode][Image] Update ...")
	var img : Image = Image.new()
	if(img.load(PathInput.text) != OK):
		print("[ImageLoader] Cannot load image from ", PathInput.text, "!")
		if(img.load("res://assets/warning.png") != OK):
			print("[ImageLoader] Cannot load warning image (BaseComponent)")
			get_tree().quit()
	var _img_data : PoolByteArray = img.get_data()
	outputs = [_img_data, img.get_size().x, img.get_size().y, img.data["format"], img.data["mipmaps"]]
	var PreviewTexture = ImageTexture.new()
	PreviewTexture.create_from_image(img)
	ImagePreview.texture = PreviewTexture