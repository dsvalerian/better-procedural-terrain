const Array3D = preload("res://Common/Data/Array3D.gd")
const VoxelFactory = preload("res://Common/Data/VoxelFactory.gd")

var density_threshold

func _init(p_density_threshold : float):
	density_threshold = p_density_threshold

# Gets an array of triangle coordinates, where each triangle is an array of Vector3s, where each
# Vector3 is a vertex. These triangles are creates using voxel data and a density_threshold value.
func get_triangles(point_cloud : Array3D):
	var voxel_factory = VoxelFactory.new()
	var triangles = []
	
	# Step through point cloud
	for x in point_cloud.x - 1:
		for y in point_cloud.y - 1:
			for z in point_cloud.z - 1:
				# Set up the voxels that are in the current cube
				var cube = [
					point_cloud.get_value(x, y, z),
					point_cloud.get_value(x, y + 1, z),
					point_cloud.get_value(x + 1, y + 1, z),
					point_cloud.get_value(x + 1, y, z),
					point_cloud.get_value(x, y, z + 1),
					point_cloud.get_value(x, y + 1, z + 1),
					point_cloud.get_value(x + 1, y + 1, z + 1),
					point_cloud.get_value(x + 1, y, z + 1),
				]
				
				# Calculate the index to lookup in the edge table
				var cube_index = 0
				for i in range(8):
					if cube[i].density < ChunkProps.DENSITY_THRESHOLD:
						cube_index += ChunkProps.CUBE_INDEX_TABLE[i]
				
				# Lookup the edge table to determine which edges have a threshold vertex on them
				# and add the vertices along the edges that makes up the triangles
				var cube_verts = []
				for i in range(12):
					cube_verts.append(null)
				
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[0]:
						cube_verts[0] = (interpolate_vertex(cube[0], cube[1]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[1]:
						cube_verts[1] = (interpolate_vertex(cube[1], cube[2]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[2]:
						cube_verts[2] = (interpolate_vertex(cube[2], cube[3]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[3]:
						cube_verts[3] = (interpolate_vertex(cube[3], cube[0]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[4]:
						cube_verts[4] = (interpolate_vertex(cube[4], cube[5]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[5]:
						cube_verts[5] = (interpolate_vertex(cube[5], cube[6]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[6]:
						cube_verts[6] = (interpolate_vertex(cube[6], cube[7]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[7]:
						cube_verts[7] = (interpolate_vertex(cube[7], cube[4]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[8]:
						cube_verts[8] = (interpolate_vertex(cube[4], cube[0]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[9]:
						cube_verts[9] = (interpolate_vertex(cube[5], cube[1]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[10]:
						cube_verts[10] = (interpolate_vertex(cube[6], cube[2]))
				if ChunkProps.EDGE_TABLE[cube_index] & ChunkProps.CUBE_INDEX_TABLE[11]:
						cube_verts[11] = (interpolate_vertex(cube[7], cube[3]))
						
				# Create and add the triangle
				var i = 0
				while ChunkProps.TRI_TABLE[cube_index][i] != -1:
					#var tri_table_entry = ChunkProps.TRI_TABLE[cube_index]
					var triangle = [
						cube_verts[ChunkProps.TRI_TABLE[cube_index][i]], 
						cube_verts[ChunkProps.TRI_TABLE[cube_index][i + 1]], 
						cube_verts[ChunkProps.TRI_TABLE[cube_index][i + 2]]
					]
					
					triangles.append(triangle)
					i += 3
					
	return triangles

# Interpolates between two voxels according to their densities and the density_threshold
# Returns the interpolated position between those two voxels
func interpolate_vertex(voxel_a : Dictionary, voxel_b : Dictionary):
	if abs(density_threshold - voxel_a.density) < 0.000001:
		return Vector3(voxel_a.x, voxel_a.y, voxel_a.z)
	if abs(density_threshold - voxel_b.density) < 0.000001:
		return Vector3(voxel_b.x, voxel_b.y, voxel_b.z)
	if abs(voxel_a.density - voxel_b.density) < 0.000001:
		return Vector3(voxel_a.x, voxel_a.y, voxel_a.z)
		
	var mid_delta = (density_threshold - voxel_a.density) / (voxel_b.density - voxel_a.density)
	return Vector3(
		voxel_a.x + mid_delta * (voxel_b.x - voxel_a.x), 
		voxel_a.y + mid_delta * (voxel_b.y - voxel_a.y), 
		voxel_a.z + mid_delta * (voxel_b.z - voxel_a.z)
	)
