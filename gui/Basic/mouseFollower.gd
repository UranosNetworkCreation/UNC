extends Label

signal ungrap

func _ready():
	self.visible = false

func grap():
	self.visible = true

func _process(_delta):
	if(self.visible):
		self.set_position(get_global_mouse_position() + Vector2(20, 20))

func _input(event):
	if(event is InputEventMouseButton && self.visible):
		var eventMBtn : InputEventMouseButton = event as InputEventMouseButton

		if(!eventMBtn.pressed):
			self.visible = false
			emit_signal("ungrap")