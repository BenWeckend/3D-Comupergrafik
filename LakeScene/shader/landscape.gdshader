shader_type spatial;

uniform sampler2D splatmap;
uniform sampler2D texture_grass;
uniform sampler2D texture_gravel;
uniform sampler2D texture_rock;
uniform sampler2D texture_mossy;
uniform sampler2D normalmap_grass : hint_normal;
uniform sampler2D normalmap_gravel : hint_normal;
uniform sampler2D normalmap_rock : hint_normal;
uniform sampler2D normalmap_mossy : hint_normal;
uniform float	  scale_grass : hint_range(0.5, 30.0, 0.1) = 1.0;
uniform float	  scale_rock : hint_range(0.5, 30.0, 0.1) = 1.0;
uniform float 	  scale_normal : hint_range(0.5, 30.0, 0.1) = 1.0;

void fragment()
{
	vec3 splat = texture(splatmap, UV).rgb;

	float rock = splat.r;
	float grass = splat.g;
	float gravel = splat.b;
	float moss = min(max(1.0 - splat.x - splat.y - splat.z, 0.0), 1.0);

	vec3 color = vec3(0);
	color += texture(texture_rock, UV * scale_rock).rgb * rock;
	color += texture(texture_grass, UV * scale_grass).rgb * grass;
	color += texture(texture_gravel, UV * scale_rock).rgb * gravel;
	color += texture(texture_mossy, UV * scale_rock).rgb * moss;
	color *= 1.0 / (rock + grass + gravel + moss);

	ALBEDO = color;
	ROUGHNESS += (grass - rock) * 0.5;

	vec3 normal = vec3(0);
	normal += texture(normalmap_rock, UV * scale_rock).rgb * rock;
	normal += texture(normalmap_grass, UV * scale_grass).rgb * grass;
	normal += texture(normalmap_gravel, UV * scale_rock).rgb * gravel;
	normal += texture(normalmap_mossy, UV * scale_rock).rgb * moss;

	NORMAL_MAP = normal;
	NORMAL_MAP_DEPTH = 0.4;

	//NORMAL = normal;
}
