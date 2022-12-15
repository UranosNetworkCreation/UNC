extends Control

# Returns true if the mouse touches the given rect
func touch_mouse(glob_rect : Rect2):
	# get mouse pos
	var mouse_pos = get_global_mouse_position()
	return (
		mouse_pos.x >= glob_rect.position.x &&
		mouse_pos.y >= glob_rect.position.y &&
		mouse_pos.x <= (glob_rect.position.x + glob_rect.size.x) &&
		mouse_pos.y <= (glob_rect.position.y + glob_rect.size.y)
	)

# Divide an array of numbers whith the given value
func DivArray(arr, div : float):
	# create an empty array for the result
	var result : PoolRealArray = PoolRealArray()

	# Divide each item of the array with the number
	for item in arr:
		var itemf : float = item
		var divresult : float = itemf/div
		result.append(divresult)

	return result

# Multiplies a array with the given value
func MultiplyArray(arr, div : float):
	return DivArray(arr, 1/div)

# Converts a String to an Array
func StrToArray(arrstr) -> PoolRealArray:
	# Split the string
	var items = arrstr.split(",")
	var result : PoolRealArray = PoolRealArray()

	for item in items:
		# Remove "[" and "]"
		item = item.replace("[", "")
		item = item.replace("]", "")

		# Add to result
		result.push_back(float(item))
	
	return result