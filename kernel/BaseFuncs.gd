extends Control

func touch_mouse(glob_rect : Rect2):
	var mouse_pos = get_global_mouse_position()
	return (
		mouse_pos.x >= glob_rect.position.x &&
		mouse_pos.y >= glob_rect.position.y &&
		mouse_pos.x <= (glob_rect.position.x + glob_rect.size.x) &&
		mouse_pos.y <= (glob_rect.position.y + glob_rect.size.y)
	)

func DivArray(arr, div : float):
	var result : PoolRealArray = PoolRealArray()
	for item in arr:
		var itemf : float = item
		var divresult : float = itemf/div
		result.append(divresult)

	return result

func MultiplyArray(arr, div : float):
	return DivArray(arr, 1/div)

func StrToArray(arrstr) -> PoolRealArray:
	var items = arrstr.split(",")
	var result : PoolRealArray = PoolRealArray()

	for item in items:
		item = item.replace("[", "")
		item = item.replace("]", "")
		result.push_back(float(item))
	
	return result