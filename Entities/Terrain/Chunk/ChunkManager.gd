extends Spatial
tool

const NoiseEngine = preload("res://Common/Util/NoiseEngine.gd")
const ChunkScene = preload("Chunk.tscn")

var noise_engine
var chunks
	
func _ready():
	noise_engine = NoiseEngine.new(
		0, # seed
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
		
	chunks = {}
	create_chunks_starting_at(Vector3(0, 0, 0), dimensions, Vector3(3, 3, 3))
	
func create_chunks_starting_at(position : Vector3, chunk_dimensions : Vector3, chunk_count : Vector3):
	for x in chunk_count.x:
		for y in chunk_count.y:
			for z in chunk_count.z:
				var chunk_position = Vector3(
					position.x + chunk_dimensions.x * x, 
					position.y + chunk_dimensions.y * y, 
					position.z + chunk_dimensions.z * z
				)
				
				create_chunk_at(chunk_position, chunk_dimensions)
	
func create_chunk_at(position : Vector3, dimensions : Vector3):
	delete_chunk_at(position)
	
	var chunk = ChunkScene.instance()
	add_child(chunk)
	chunk.init_scene(noise_engine, position, dimensions, ChunkProps.STEP_SIZE, ChunkProps.DENSITY_THRESHOLD)
	chunk.create_point_cloud()
	#chunk.render_point_cloud()
	chunk.create_mesh()
	chunks[position] = chunk

func delete_chunk_at(position : Vector3):
	if chunks.has(position):
		chunks[position].queue_free()
		chunks.erase(position)
