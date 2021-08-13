var noise
	
func _init(p_seed, lacunarity, octaves, period, persistence):
	noise = OpenSimplexNoise.new()
	noise.seed = p_seed
	noise.lacunarity = lacunarity
	noise.octaves = octaves
	noise.period = period
	noise.persistence = persistence

func get_noise(size, x, y):
	pass
	#var noise_array = Array2D.new(size, size)
	#for i in size:
	#	for j in size:
	#		noise_array.set_value(i, j, noise.get_noise_2d(x + i, y + j))

	#return noise_array
