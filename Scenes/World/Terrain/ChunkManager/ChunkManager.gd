extends Spatial
tool

const NoiseEngine = preload("res://Scripts/Common/NoiseEngine.gd")
const ChunkScene = preload("res://Scenes/World/Terrain/Chunk/Chunk.tscn")

var noise_engine
var chunk

func _init():
	noise_engine = NoiseEngine.new(randi(), 2.0, 3.0, 20.0, 0.5)
	var noise = noise_engine.get_noise(ChunkProperties.DIMENSION.x, 0.0, 0.0)
	
	chunk = ChunkScene.instance()
	add_child(chunk)
	chunk.init(Vector3(0.0, 0.0, 0.0))
	chunk.update(noise)
	
