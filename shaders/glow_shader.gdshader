shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.8, 0.2, 1.0);
uniform float pulse_speed : hint_range(0.1, 10.0) = 2.0;
uniform float min_intensity : hint_range(0.0, 1.0) = 0.2;
uniform float max_intensity : hint_range(0.0, 2.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float pulse = (sin(TIME * pulse_speed) + 1.0) * 0.5;
    float intensity = mix(min_intensity, max_intensity, pulse);
    vec3 final_color = tex_color.rgb + (glow_color.rgb * intensity);
    
    COLOR = vec4(final_color, tex_color.a);
}