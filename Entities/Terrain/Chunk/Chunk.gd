extends StaticBody
tool

const Array3D = preload("res://Common/Data/Array3D.gd")
const VoxelFactory = preload("res://Common/Data/VoxelFactory.gd")
const NoiseEngine = preload("res://Common/Util/NoiseEngine.gd")
const VectorUtil = preload("res://Common/Util/VectorUtil.gd")
const MarchingCubes = preload("MarchingCubes.gd")
const DebugPointCloudShader = preload("Assets/Shaders/DebugPointCloud.shader")
const DebugEdgeVertexShader = preload("Assets/Shaders/DebugEdgeVertex.shader")
const TerrainShader = preload("Assets/Shaders/Terrain.shader")
const TerrainMaterial = preload("Assets/Materials/Terrain.tres")

const FLOAT_THRESHOLD = 0.00001

var noise_engine
var position
var dimensions
var step_size
var density_threshold
var amplitude

var point_cloud
var surface_mesh_instance
var mesh_triangles
var mesh_edge_triangles

func init_scene(p_noise_engine : NoiseEngine, p_position : Vector3, p_dimensions : Vector3, p_step_size, p_density_threshold, p_amplitude):
	set_position(p_position)
	noise_engine = p_noise_engine
	dimensions = p_dimensions
	step_size = p_step_size
	density_threshold = p_density_threshold
	amplitude = p_amplitude
	
	mesh_triangles = {}
	mesh_edge_triangles = {}
	
func set_position(p_position : Vector3):
	position = p_position
	global_transform.origin = position
	
func create_point_cloud():
	var voxel_factory = VoxelFactory.new()
	
	point_cloud = Array3D.new(
		int((dimensions.x + step_size) / step_size),
		int((dimensions.y + step_size) / step_size),
		int((dimensions.z + step_size) / step_size)
	)
	
	# Filling the point cloud with voxel data
	for x in point_cloud.x:
		for y in point_cloud.y:
			for z in point_cloud.z:
				# Setting up a voxel with the relative position
				var voxel = voxel_factory.new_voxel(
					x * step_size,
					y * step_size,
					z * step_size
				)
				
				voxel.density = noise_engine.get_noise(
					voxel.x + position.x, 
					voxel.y + position.y, 
					voxel.z + position.z
				) - (voxel.y + position.y) / amplitude
				
				# Storing the voxel in the array
				point_cloud.set_value(x, y, z, voxel)
	
func render_point_cloud():
	# Set up surface tool and material/shader
	var spatial_material = ShaderMaterial.new()
	spatial_material.shader = DebugPointCloudShader
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_POINTS)
	surface_tool.set_material(spatial_material)
	
	# Step through point cloud to add vertices 
	for x in point_cloud.x:
		for y in point_cloud.y:
			for z in point_cloud.z:
				var voxel = point_cloud.get_value(x, y, z)
				var vertex = Vector3(voxel.x, voxel.y, voxel.z)
				surface_tool.add_vertex(vertex)

	# Commit vertices to mesh and add to scene
	var mesh_instance = MeshInstance.new()
	mesh_instance.set_mesh(surface_tool.commit())
	add_child(mesh_instance)
	
func create_initial_mesh():
	# Unload mesh if it exists
	if surface_mesh_instance != null:
		surface_mesh_instance.queue_free()
		surface_mesh_instance = null
		
	# Set up surface tool and material
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	surface_tool.set_material(TerrainMaterial)
	surface_tool.add_smooth_group(true)
	
	# Generate triangles using marching cubes
	var marching_cubes = MarchingCubes.new(density_threshold)
	var triangles = marching_cubes.get_triangles(point_cloud)
	
	# Step through triangles to generate mesh
	for triangle in triangles:
		for vertex in triangle:
			if is_edge_vertex(vertex):
				# If vertex is already in the dict, add the triangle to the existing list
				if mesh_edge_triangles.has(VectorUtil.vector_hash(vertex)):
					mesh_edge_triangles[VectorUtil.vector_hash(vertex)].append(triangle)
				# Otherwise, create a new list with the triangle as the only element for this vertex
				else:
					mesh_edge_triangles[VectorUtil.vector_hash(vertex)] = [triangle]
			
			var uv_coord = Vector2(vertex.x / dimensions.x, vertex.z / dimensions.z)
			surface_tool.add_uv(uv_coord)
			surface_tool.add_vertex(vertex)
			
	# Commit vertices to mesh and add to scene
	surface_tool.generate_normals()
	surface_mesh_instance = MeshInstance.new()
	surface_mesh_instance.set_mesh(surface_tool.commit())
	add_child(surface_mesh_instance)
	
func render_edge_vertices():
	#print("Rendering edge vertices", mesh_edge_triangles.size())
	# Set up surface tool and material/shader
	var spatial_material = ShaderMaterial.new()
	spatial_material.shader = DebugEdgeVertexShader
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_POINTS)
	surface_tool.set_material(spatial_material)
	
	for vertex_hash in mesh_edge_triangles.keys():
		surface_tool.add_vertex(VectorUtil.vector_unhash(vertex_hash))

	# Commit vertices to mesh and add to scene
	var mesh_instance = MeshInstance.new()
	mesh_instance.set_mesh(surface_tool.commit())
	add_child(mesh_instance)

# Checks to see if a vertex is on the edge of the bounding box.
func is_edge_vertex(vertex : Vector3):
	var offset_x = position.x
	var offset_y = position.y
	var offset_z = position.z
	
	var min_x = position.x - offset_x
	var min_y = position.y - offset_y
	var min_z = position.z - offset_z
	var max_x = position.x + dimensions.x - offset_x
	var max_y = position.y + dimensions.y - offset_y
	var max_z = position.z + dimensions.z - offset_z
	
	if abs(vertex.x - min_x) < ChunkProps.FLOAT_THRESHOLD or \
	   abs(vertex.x - max_x) < ChunkProps.FLOAT_THRESHOLD or \
	   abs(vertex.y - min_y) < ChunkProps.FLOAT_THRESHOLD or \
	   abs(vertex.y - max_y) < ChunkProps.FLOAT_THRESHOLD or \
	   abs(vertex.z - min_z) < ChunkProps.FLOAT_THRESHOLD or \
	   abs(vertex.z - max_z) < ChunkProps.FLOAT_THRESHOLD:
		return true
		
	return false
