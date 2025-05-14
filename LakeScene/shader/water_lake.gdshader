shader_type spatial;

uniform float scale_uv : hint_range(0.25,10.0,0.25) = 1.0;
uniform float scale_height : hint_range(0.0,5.0,0.1) = 0.2;
uniform float wave_speed : hint_range(0.0,1.0,0.01) = 0.05;
uniform vec3 color_water : source_color;
uniform vec3 color_depth : source_color;
uniform sampler2D noise : hint_default_black;
uniform sampler2D noise_normalmap : hint_normal;


//float wave(vec2 pos, vec2 org, float time, float strength)
//{
//	pos += texture(noise, pos / 10.0).x * 1. - .5;
//	float d = -distance(pos, org);
//	return sin(d * 10.0 / strength + time * wave_speed * 100.0) * pow(2.0, d) * strength;
//}

float wave(vec2 pos){
	return (2.0*texture(noise, pos*1.0).r - 1.0) * scale_height;
}

float height(vec2 pos, float time) 
{
	pos += vec2(0.2,0.3) * time * wave_speed;
	
	float h = wave(pos+offset) * 0.55; 
	h += wave(pos*1.5) * 0.3;
	h += wave(pos*2.5) * 0.1;
	return h;
	
	//float height = 0.0;
	//height += texture(noise, pos).x * 0.2;
	//
	//vec3 sources[] = { vec3(1, -8, 0.7), vec3(5, 2, 0.3), vec3(-4, 2, 0.3) };
	//for (int i = 0; i < 3; i++)
	//	height += wave(pos, sources[i].xy, time, sources[i].z);
	//
	//return height * scale_height;
}


varying vec2 _pos;
void vertex() 
{
	vec2 pos = UV*scale_uv;
	VERTEX.y += height(UV*scale_uv, TIME);
	float d = 0.25;
	float l = height(pos - vec2(d, 0.0), TIME);
	float r = height(pos + vec2(d, 0.0), TIME);
	float t = height(pos - vec2(0.0, d), TIME);
	float b = height(pos + vec2(0.0, d), TIME);
	
	NORMAL = normalize(vec3((r-l)/(2.0*d),1.0,(b-t)/(2.0*d)));
	//VERTEX.y += (2.0*texture(noise, UV*scale_uv*1.0).x - 1.0) * scale_height;

//	vec2 pos = VERTEX.xz * scale_uv;
//	_pos = pos;
//	float h = height(pos, TIME);
//	VERTEX.y = h;
//	NORMAL = normalize(vec3(
//		h - height(pos + vec2(0.01, 0), TIME), 
//		scale_height, 
//		h - height(pos + vec2(0, 0.01), TIME)
//	));
}

void fragment() 
{
	//NORMAL_MAP = (2.0*texture(noise_normalmap, UV*scale_uv*1.0).xyz - 1.0);
	ALBEDO = color_water;
	SPECULAR = 1.0;
	ROUGHNESS = 0.1;
	
	
}



