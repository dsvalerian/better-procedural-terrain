var x
var y
var z
var size
var values
	
func _init(p_x : int, p_y : int, p_z : int):
	x = p_x
	y = p_y
	z = p_z
	size = x * y * z
	
	values = []
	for i in x:
		values.append([])
		
		for j in y:
			values[i].append([])
			
			for k in z:
				values[i][j].append(null)
	
func set_value(pos_x : int, pos_y : int, pos_z : int, value):
	values[pos_x][pos_y][pos_z] = value

func get_value(pos_x : int, pos_y : int, pos_z : int):
	return values[pos_x][pos_y][pos_z]
