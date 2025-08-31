shader_type canvas_item;
render_mode unshaded, skip_vertex_transform;

uniform sampler2D screen_tex : hint_screen_texture;


uniform int   firefly_count    : hint_range(1,20)    = 8;
uniform float firefly_size     : hint_range(0.0,0.01)= 0.002;
uniform float glow_intensity   : hint_range(0.0,1.0) = 0.15;
uniform float movement_speed   : hint_range(0.0,1.0) = 0.05;
uniform float movement_range   : hint_range(0.0,0.5) = 0.2;
uniform float flicker_speed    : hint_range(0.0,10.0)= 1.0;
uniform float flicker_rhythm   : hint_range(0.0,5.0) = 1.5;
uniform float disappear_chance : hint_range(0.0,1.0) = 0.02;


uniform float darken_factor   : hint_range(0.0,1.0) = 0.05; // scuritura leggera
uniform float vignette_power  : hint_range(1.0,8.0) = 2.0;  // caduta morbida
uniform float border_darkness : hint_range(0.0,4.0) = 2.6;  // vignetta poco evidente


float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898,78.233))) * 43758.5453);
}

float glow(vec2 uv, vec2 pos, float size) {
    float d = length(uv - pos);
    return exp(-d*d/(size*size));
}

vec3 randomColor(float seed) {
    float choice = fract(seed * 123.456);
    if (choice < 0.33) return vec3(0.20, 0.50, 1.00);
    else if (choice < 0.66) return vec3(0.30, 1.00, 0.30);
    else return vec3(0.60, 0.30, 1.00);
}

void fragment() {
    vec2 uv = SCREEN_UV;
    vec2 center = vec2(0.5);


    vec3 base_color = texture(screen_tex, uv).rgb;
    base_color *= (1.0 - darken_factor);


    vec2 vuv = (uv - center);
    float dist = length(vuv);
    float vignette = clamp(pow(dist, vignette_power) * border_darkness, 0.0, 1.0);
    base_color *= (1.0 - vignette);


    vec3 firefly_color = vec3(0.0);

    for (int i = 0; i < firefly_count; i++) {
        float fi = float(i);
        float seedX = rand(vec2(fi, 0.0));
        float seedY = rand(vec2(fi, 1.0));
        float seedT_flicker = rand(vec2(fi, 2.0));
        float seedT_disappear = rand(vec2(fi, 3.0));
        float seedCol = rand(vec2(fi, 4.0));
        float seedOffset = rand(vec2(fi, 5.0));

        float t = TIME * movement_speed + seedOffset * 10.0;
        vec2 initial_pos = vec2(seedX, seedY);
        vec2 movement = vec2(
            sin(t + fi * 10.0),
            cos(t + fi * 20.0)
        ) * movement_range;
        vec2 pos = initial_pos + movement;

        float flicker = pow(sin(TIME * flicker_speed + seedT_flicker * 5.0) * 0.5 + 0.5, flicker_rhythm);
        float disappear = smoothstep(0.0, disappear_chance, sin(TIME * 0.1 + seedT_disappear * 10.0));
        float alpha = glow_intensity * flicker * disappear;

        vec3 col = randomColor(seedCol);
        firefly_color += col * glow(uv, pos, firefly_size) * alpha;
    }

    COLOR = vec4(base_color + firefly_color, 1.0);
}
