extends "../.Input.gd"

# slots
const OUTPUT_DATA2D = 0
const OUTPUT_SIZEX = 1
const OUTPUT_SIZEY = 2
const OUTPUT_FORMAT = 3
const OUTPUT_MIPMAP = 4

# essencial nodes
var PathInput
var ImagePreview : TextureRect

func _ready():
	# Assign nodes to vars
	PathInput = get_node("LineEdit")
	ImagePreview = get_node("TextureRect")

# normal calculation process
func updateCalc():
	print("[gNode][Image] Update ...")
	# Create image
	var img : Image = Image.new()

	# Try to load image
	if(img.load(PathInput.text) != OK):
		print("[ImageLoader] Cannot load image from ", PathInput.text, "!")
		
		# Load another image instead
		if(img.load("res://assets/warning.png") != OK):
			print("[ImageLoader] Cannot load warning image (BaseComponent)")
			get_tree().quit()

	# Grap data
	var _img_data : PoolByteArray = img.get_data()
	# Update outputs
	outputs = [_img_data, img.get_size().x, img.get_size().y, img.data["format"], img.data["mipmaps"]]
	
	# Update preview
	var PreviewTexture = ImageTexture.new()
	PreviewTexture.create_from_image(img)
	ImagePreview.texture = PreviewTexture