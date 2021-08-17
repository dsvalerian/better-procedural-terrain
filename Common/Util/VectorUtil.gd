static func vector_hash(vector : Vector3):
	return str(vector.x) + "_" + str(vector.y) + "_" + str(vector.z)

static func vector_unhash(vector_hash : String):
	var split_array = vector_hash.split("_")
	return Vector3(split_array[0], split_array[1], split_array[2])
