shader_type spatial;
render_mode unshaded, cull_disabled;

uniform float point_size = 10.0;
uniform vec3 color = vec3(0.0, 1.0, 1.0);
uniform float alpha = 0.1;

uniform vec3 camera_pos;

void vertex() {
	POINT_SIZE = point_size;
}

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}