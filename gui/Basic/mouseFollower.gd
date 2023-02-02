extends Label

signal ungrap

func _ready():
	# Hide on start
	self.visible = false

func grap():
	# Set visible to true when not is graped
	self.visible = true

func _process(_delta):
	# Set the position under the mouse if visible
	if(self.visible):
		self.set_position(get_global_mouse_position() + Vector2(20, 20))

func _input(event):
	# Hide if left mouse btn up
	if(event is InputEventMouseButton && self.visible):
		var eventMBtn : InputEventMouseButton = event as InputEventMouseButton

		if(!eventMBtn.pressed):
			self.visible = false
			emit_signal("ungrap")
