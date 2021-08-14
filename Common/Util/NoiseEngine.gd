const Array3D = preload("res://Common/Data/Array3D.gd")

var noise
	
func _init(p_seed : int, scale : float, lacunarity : float, octaves : int, persistence : float):
	noise = OpenSimplexNoise.new()
	noise.seed = p_seed
	noise.period = scale
	noise.lacunarity = lacunarity
	noise.octaves = octaves
	noise.persistence = persistence
	
func get_noise(x, y, z):
	return noise.get_noise_3d(x, y, z)
