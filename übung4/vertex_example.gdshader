shader_type spatial;
render_mode unshaded, skip_vertex_transform;

void vertex() {
	vec4 v = vec4(VERTEX, 1.0);

	// Rotation X-Achse
	float a = TIME * 0.5;
	mat4 rot = mat4(
		vec4(1.0,    0.0,     0.0, 0.0),
		vec4(0.0, cos(a), -sin(a), 0.0),
		vec4(0.0, sin(a),  cos(a), 0.0),
		vec4(0.0,    0.0,     0.0, 1.0)
	);

	v = rot * v;                     // lokalen Raum rotation
	v = MODEL_MATRIX * v;            // Weltkoordinaten
	v = VIEW_MATRIX * v;             // Kamera-Koordinaten
	POSITION = PROJECTION_MATRIX * v; 
}

void fragment() {
	ALBEDO = vec3(1.0, 0.0, 0.0);
}
