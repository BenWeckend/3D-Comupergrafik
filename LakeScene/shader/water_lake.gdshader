shader_type spatial;

uniform float scale_uv : hint_range(0.25,10.0,0.25) = 1.0;
uniform float scale_height : hint_range(0.0,5.0,0.1) = 0.2;
uniform float wave_speed : hint_range(0.0,1.0,0.01) = 0.05;
uniform vec3 color_water : source_color = vec3(0.0, 0.2, 0.6);
uniform vec3 color_depth : source_color = vec3(0.2, 0.05, 0.1);
uniform sampler2D noise : hint_default_black;
uniform sampler2D noise_normalmap : hint_normal;

uniform sampler2D depth_texture : source_color, hint_depth_texture;
uniform sampler2D screen_texture : source_color, hint_screen_texture;
varying float world_height;

float wave(vec2 pos) {
	return (2.0 * texture(noise, pos * 1.0).r - 1.0) * scale_height;
}

float height(vec2 pos, float time) {
	vec2 offset = vec2(0.2, 0.3) * time * wave_speed;
	pos += offset;

	float h = wave(pos + vec2(0.1)) * 0.01; 
	h += wave(pos * 1.5) * 0.1;
	h += wave(pos * 2.5) * 0.1;
	return h;
}

void vertex() {
	vec2 pos = VERTEX.xz * scale_uv;
	float d = 0.05;

	float h = height(pos, TIME);
	float l = height(pos - vec2(d, 0.0), TIME);
	float r = height(pos + vec2(d, 0.0), TIME);
	float t = height(pos - vec2(0.0, d), TIME);
	float b = height(pos + vec2(0.0, d), TIME);

	VERTEX.y += h;

	//world_height = (vec4(VERTEX, 1.0,) * MODEL_MATRIX).y;
	NORMAL = normalize(vec3((r - l) / (2.0 * d), 1.0, (b - t) / (2.0 * d)));
	
	//EMISSION = color_water * 0.15;
}

void fragment() {
	//ALBEDO = color_water;
	
	float depth_raw = texture(depth_texture, SCREEN_UV).r;
	vec4 ndc = vec4(SCREEN_UV*2.0 - 1.0, depth_raw, 1.0);
	vec4 depth_world = INV_VIEW_MATRIX * INV_PROJECTION_MATRIX * ndc;
	depth_world /= depth_world.w;
	
	float depth = abs(depth_world.y - world_height);
	float depth_blend = min(pow(depth, 1.5), 1.0);
	
	vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
	vec3 water = mix(color_water, color_depth, depth_blend);
	ALBEDO = mix(screen_color, water, depth_blend);
	SPECULAR = 1.0;
	ROUGHNESS = 0.4;
	METALLIC = 0.1;
	
	
	NORMAL_MAP = texture(noise_normalmap, UV*scale_uv * 2.0).xyz;
	NORMAL_MAP_DEPTH = 0.5;
	
}