extends Control

func touch_mouse(glob_rect : Rect2):
	var mouse_pos = get_global_mouse_position()
	return (
		mouse_pos.x >= glob_rect.position.x &&
		mouse_pos.y >= glob_rect.position.y &&
		mouse_pos.x <= (glob_rect.position.x + glob_rect.size.x) &&
		mouse_pos.y <= (glob_rect.position.y + glob_rect.size.y)
	)