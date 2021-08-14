func new_voxel(pos_x, pos_y, pos_z):
	var new_voxel = {}
	new_voxel.density = 0
	new_voxel.x = pos_x
	new_voxel.y = pos_y
	new_voxel.z = pos_z
	
	return new_voxel

func get_midpoint(voxel_a : Dictionary, voxel_b : Dictionary):
	var pos_a = Vector3(voxel_a.x, voxel_a.y, voxel_a.z)
	var pos_b = Vector3(voxel_b.x, voxel_b.y, voxel_b.z)
	
	return pos_a.move_toward(pos_b, 0.5)
