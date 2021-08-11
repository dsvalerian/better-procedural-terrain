extends StaticBody
tool

var cubes = []

var surface_tool
var mesh
var mesh_instance
var position
	
func init(p_position):
	surface_tool = SurfaceTool.new()
	mesh = null
	mesh_instance = null
	position = p_position

func update(noise_array_2d):
	unload_mesh()
	create_mesh(noise_array_2d)
	
func unload_mesh():
	if mesh_instance != null:
		mesh_instance.call_deferred("queue_free")
		mesh_instance = null
		
func create_mesh(noise_array_2d):
	mesh = Mesh.new()
	mesh_instance = MeshInstance.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	
	# Create blocks for each point in the chunk dimensions
	for x in ChunkProperties.DIMENSION.x:
		for z in ChunkProperties.DIMENSION.y:
			var y = noise_array_2d.get_value(x, z)
			create_block(position.x + x, position.y + y, position.z + z)

	# Commit changes to the mesh
	surface_tool.generate_normals(false)
	surface_tool.commit(mesh)
	mesh_instance.set_mesh(mesh)
	
	add_child(mesh_instance)
	mesh_instance.create_trimesh_collision()

func create_block(x, y, z):
	create_face(CubeProperties.TOP, x, y, z)
	create_face(CubeProperties.BOTTOM, x, y, z)
	create_face(CubeProperties.LEFT, x, y, z)
	create_face(CubeProperties.RIGHT, x, y, z)
	create_face(CubeProperties.FRONT, x, y, z)
	create_face(CubeProperties.BACK, x, y, z)
	
func create_face(index, x, y, z):
	var offset = Vector3(x, y, z)
	var a = CubeProperties.vertices[index[0]] + offset
	var b = CubeProperties.vertices[index[1]] + offset
	var c = CubeProperties.vertices[index[2]] + offset
	var d = CubeProperties.vertices[index[3]] + offset
	
	surface_tool.add_triangle_fan([a, b, c])
	surface_tool.add_triangle_fan([a, c, d])
