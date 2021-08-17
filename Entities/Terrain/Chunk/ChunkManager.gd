extends Spatial
tool

const NoiseEngine = preload("res://Common/Util/NoiseEngine.gd")
const VectorUtil = preload("res://Common/Util/VectorUtil.gd")
const ChunkScene = preload("Chunk.tscn")
const ChunkStitcher = preload("ChunkStitcher.gd")

var noise_engine
var chunks
	
func _ready():
	noise_engine = NoiseEngine.new(
		ChunkProps.SEED,
		ChunkProps.SCALE, 
		ChunkProps.LACUNARITY, 
		ChunkProps.OCTAVES, 
		ChunkProps.PERSISTENCE
	)
	
	var dimensions = Vector3(
		ChunkProps.DIMENSION.x,
		ChunkProps.DIMENSION.y, 
		ChunkProps.DIMENSION.z
	)
	
	var chunk_count = Vector3(4, 3, 4)
	var offset_pos = Vector3(
		-(chunk_count.x * dimensions.x / 2), 
		-(chunk_count.y * dimensions.y / 2), 
		-(chunk_count.z * dimensions.z / 2)
	)
		
	chunks = {}
	create_chunks_starting_at(offset_pos, dimensions, chunk_count)
	
func create_chunks_starting_at(position : Vector3, chunk_dimensions : Vector3, chunk_count : Vector3):
	# Looping through each position where chunks should be created and creating them
	for x in chunk_count.x:
		for y in chunk_count.y:
			for z in chunk_count.z:
				var chunk_position = Vector3(
					position.x + chunk_dimensions.x * x, 
					position.y + chunk_dimensions.y * y, 
					position.z + chunk_dimensions.z * z
				)
				
				create_chunk_at(chunk_position, chunk_dimensions)
				
	stitch_chunks()
	
func create_chunk_at(position : Vector3, dimensions : Vector3):
	# Delete any existing chunk that may be at this position
	delete_chunk_at(position)
	
	# Creating a chunk object and adding it into the scene
	var chunk = ChunkScene.instance()
	add_child(chunk)
	chunks[VectorUtil.vector_hash(position)] = chunk
	
	# Initializing the chunk and creating point cloud/mesh/etc
	chunk.init_scene(
		noise_engine, 
		position, 
		dimensions, 
		ChunkProps.STEP_SIZE, 
		ChunkProps.DENSITY_THRESHOLD, 
		ChunkProps.AMPLITUDE
	)
	
	chunk.create_point_cloud()
	chunk.render_point_cloud()
	chunk.create_initial_mesh()
	chunk.render_edge_vertices()

func delete_chunk_at(position : Vector3):
	if chunks.has(position):
		chunks[VectorUtil.vector_hash(position)].queue_free()
		chunks.erase(position)
		
func stitch_chunks():
	ChunkStitcher.new().stitch_chunks(chunks)
