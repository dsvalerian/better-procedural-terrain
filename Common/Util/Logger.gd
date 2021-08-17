const DEBUG_PREFIX = "DEBUG -- "

static func debug_vector3(vector : Vector3, optional_prefix = "Vector3"):
	print(DEBUG_PREFIX + optional_prefix + \
		" (" + str(vector.x) + ", " + str(vector.y) + ", " + str(vector.z) + ")")
