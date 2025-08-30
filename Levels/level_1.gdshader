shader_type canvas_item;
render_mode unshaded, skip_vertex_transform, blend_add;

uniform int firefly_count : hint_range(1,20) = 8;        // meno lucciole
uniform float firefly_size : hint_range(0.0,0.01) = 0.002;
uniform float glow_intensity : hint_range(0.0,1.0) = 0.15; // più tenue
uniform float border_darkness : hint_range(0.0,1.0) = 1.0;
uniform float movement_speed : hint_range(0.0,1.0) = 0.05;
uniform float movement_range : hint_range(0.0,0.5) = 0.2;
uniform float flicker_speed : hint_range(0.0,10.0) = 1.0;
uniform float flicker_rhythm : hint_range(0.0,5.0) = 1.5;
uniform float disappear_chance : hint_range(0.0,1.0) = 0.02; // più bassa

// --- Funzioni ---
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233)))*43758.5453);
}

float glow(vec2 uv, vec2 pos, float size) {
    float dist = length(uv - pos);
    return exp(-dist*dist/(size*size));
}

vec3 randomColor(float seed) {
    float choice = fract(seed*123.456);
    if (choice<0.33) return vec3(0.2,0.5,1.0);     // azzurro
    else if (choice<0.66) return vec3(0.3,1.0,0.3); // verde
    else return vec3(0.6,0.3,1.0);                 // viola
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center = vec2(0.5);

    // --- Vignetta nera ai bordi e angoli ---
    float dist_from_center = length(uv-center);
    float vignette = clamp(1.0 - pow(dist_from_center,4.0)*border_darkness, 0.0, 1.0);
    vec3 color = vec3(0.0);
    color = mix(vec3(0.0), vec3(0.0), vignette);

    // --- Lucciole animate ---
    for (int i=0;i<firefly_count;i++){
        float fi = float(i);
        float seedX = rand(vec2(fi,0.0));
        float seedY = rand(vec2(fi,1.0));
        float seedT_flicker = rand(vec2(fi,2.0));
        float seedT_disappear = rand(vec2(fi,3.0));
        float seedCol = rand(vec2(fi,4.0));
        float seedOffset = rand(vec2(fi,5.0));

        // Movimento fluido
        float time_offset = TIME * movement_speed + seedOffset * 10.0;
        vec2 initial_pos = vec2(seedX, seedY);
        vec2 movement = vec2(
            sin(time_offset + fi * 10.0),
            cos(time_offset + fi * 20.0)
        ) * movement_range;
        vec2 pos = initial_pos + movement;

        // Sfarfallio naturale + sparizione graduale
        float flicker = pow(sin(TIME * flicker_speed + seedT_flicker * 5.0) * 0.5 + 0.5, flicker_rhythm);
        float disappear_factor = smoothstep(0.0, disappear_chance, sin(TIME * 0.1 + seedT_disappear * 10.0));
        float current_alpha_multiplier = flicker * disappear_factor;

        float alpha = current_alpha_multiplier * glow_intensity;
        vec3 col = randomColor(seedCol);

        color += col * glow(uv,pos,firefly_size) * alpha;
    }

    COLOR = vec4(color,1.0);
}
