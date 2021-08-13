extends StaticBody
tool

const Array3D = preload("res://Common/Data/Array3D.gd")
const VoxelManager = preload("res://Common/Data/Voxel.gd")
const DebugPointCloudShader = preload("DebugPointCloud.shader")

var position
var point_cloud
	
func _ready():
	set_position(0, 0, 0)
	point_cloud = create_point_cloud()
	render_point_cloud()
	
func set_position(x, y, z):
	position = Vector3(x, y, z)
	
func create_point_cloud():
	print("Creating point cloud...")
	
	var voxel_manager = VoxelManager.new()
	
	var new_point_cloud = Array3D.new(
		ChunkProperties.DIMENSION.x / ChunkProperties.STEP_SIZE,
		ChunkProperties.DIMENSION.y / ChunkProperties.STEP_SIZE,
		ChunkProperties.DIMENSION.z / ChunkProperties.STEP_SIZE
	)
	
	# Filling the point cloud with voxel data
	for x in new_point_cloud.x:
		for y in new_point_cloud.y:
			for z in new_point_cloud.z:
				# Setting up a voxel with the relative position
				var voxel = voxel_manager.new_voxel(
					x * ChunkProperties.STEP_SIZE,
					y * ChunkProperties.STEP_SIZE,
					z * ChunkProperties.STEP_SIZE
				)
				
				# Storing the voxel in the array
				new_point_cloud.set_value(x, y, z, voxel)
				
	print("Done")
				
	return new_point_cloud
	
func render_point_cloud():
	print("Rendering point cloud...")
	
	var point_cloud_mesh = Mesh.new()
	var spatial_material = ShaderMaterial.new()
	spatial_material.shader = DebugPointCloudShader
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_POINTS)
	surface_tool.set_material(spatial_material)
	
	for x in point_cloud.x:
		for y in point_cloud.y:
			for z in point_cloud.z:
				var voxel = point_cloud.get_value(x, y, z)
				var vertex = Vector3(voxel.pos_x, voxel.pos_y, voxel.pos_z)
				surface_tool.add_color(Color(1, 0, 0))
				surface_tool.add_vertex(vertex)

	var new_mesh = surface_tool.commit()
	var mesh_instance = MeshInstance.new()
	mesh_instance.set_mesh(new_mesh)
	add_child(mesh_instance)

	print("Done")
