const VectorUtil = preload("res://Common/Util/VectorUtil.gd")
const Logger = preload("res://Common/Util/Logger.gd")

var edge_triangles
var vertex_normals

func _init():
	edge_triangles = {}
	vertex_normals = {}
	
func stitch_chunks(chunks):
	# Loop through each chunk to fill dict of edge triangles
	for chunk_hash in chunks.keys():
		var chunk = chunks[chunk_hash]
		var edge_triangles = chunk.mesh_edge_triangles
		
		# Loop through each vertex in this chunk's edge vertices
		for vertex_hash in edge_triangles.keys():
			add_triangles(vertex_hash, edge_triangles[vertex_hash])
		
	generate_normals()
	
# Vertex is a hash of a Vector3 in the form of "x_y_z"
# Triangle is an array[3] of vertices (Vector3, Vector3, Vector3).
func add_triangles(vertex_hash : String, triangles : Array):
	for triangle in triangles:
		if edge_triangles.has(vertex_hash):
			edge_triangles[vertex_hash].append(triangle)
		else:
			edge_triangles[vertex_hash] = [triangle]
	
func clear():
	edge_triangles.clear()
	vertex_normals.clear()

func generate_normals():
	if not vertex_normals.empty():
		vertex_normals.clear()
		
	vertex_normals = {}
	
	for vertex_hash in edge_triangles.keys():
		var triangles = edge_triangles[vertex_hash]
		var vertex_normal = Vector3(0, 0, 0)
		
		for triangle in triangles:
			# Calculating face normal and adding it to the vertex normal
			vertex_normal += (triangle[1] - triangle[0]).cross(triangle[2] - triangle[0]).normalized()
			
		vertex_normals[vertex_hash] = vertex_normal.normalized()
		Logger.debug_vector3(vertex_normal.normalized())
