shader_type spatial;

void vertex() {
	vec3 v = VERTEX;
	float waveX = UV.x * 40.0;
	float waveY = UV.y * 40.0;
	vec2 w = vec2(waveX, waveY);
	
	vec2 dir = vec2(0.2, 0.5);
	w += dir * TIME * 0.5;
	
	float h = (sin(w.x) + cos(w.y)) * 0.5;
	
	v.y += h;
	
	VERTEX = v;
}

void fragment() {
	ALBEDO = vec3(UV, 0.1);
}
