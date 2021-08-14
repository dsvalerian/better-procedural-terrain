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
	
	var chunk_count = Vector3(4, 2, 4)
	var offset_pos = Vector3(
		-(chunk_count.x * dimensions.x / 2), 
		-(chunk_count.y * dimensions.y / 2), 
		-(chunk_count.z * dimensions.z / 2)
	)
		
	chunks = {}
	create_chunks_starting_at(offset_pos, dimensions, chunk_count)
	
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
	chunk.init_scene(noise_engine, position, dimensions, ChunkProps.STEP_SIZE, ChunkProps.DENSITY_THRESHOLD, ChunkProps.AMPLITUDE)
	chunk.create_point_cloud()
	#chunk.render_point_cloud()
	chunk.create_mesh()
	chunks[position] = chunk

func delete_chunk_at(position : Vector3):
	if chunks.has(position):
		chunks[position].queue_free()
		chunks.erase(position)
