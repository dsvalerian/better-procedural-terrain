shader_type spatial;
//render_mode unshaded;

uniform int tile_amount;
uniform sampler2D grass_texture;
uniform sampler2D stone_texture;

varying vec3 normal;

float get_slope(float height_normal) {
	float slope = 1.0 - height_normal;
	slope *= slope;
	return slope * 128.0;
}

void vertex() {
	normal = NORMAL;
}

void fragment() {
	vec2 tiled_uv = vec2(UV.x * float(tile_amount), UV.y * float(tile_amount));
	vec3 grass_value = texture(grass_texture, tiled_uv).rgb;
	vec3 stone_value = texture(stone_texture, tiled_uv).rgb;
	
	float slope = clamp(get_slope(normal.y), 0.0, 1.0);
	vec3 grass_mixin = mix(grass_value, stone_value, slope);
	
	ALBEDO = grass_mixin;
}