var width
var height
var data
	
func _init(width, height):
	set_dimensions(width, height)
	clear()
	
func set_dimensions(p_width, p_height):
	width = p_width
	height = p_height
		
func get_value(x, y):
	return data[y * width + x]

func set_value(x, y, value):
	data[y * width + x] = value

func clear():
	data = Array()
	
	for i in width * height:
		data.append(0.0)

func get_size():
	return width * height

func get_height():
	return height
	
func get_width():
	return width
