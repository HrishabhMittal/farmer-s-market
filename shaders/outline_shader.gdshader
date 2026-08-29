shader_type canvas_item;

uniform bool enable_outline = true;
uniform vec4 line_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float line_scale : hint_range(0.0, 50.0, 0.1) = 1.0;

void fragment() {
    vec4 sprite_color = texture(TEXTURE, UV);

    if (!enable_outline) {
        COLOR = sprite_color;
    } else {
        vec2 size = TEXTURE_PIXEL_SIZE * line_scale;
        float alpha = sprite_color.a;
        float max_alpha = alpha;
		
		// Find if it is a edge pixel or not
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(0.0, -size.y)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(0.0, size.y)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(-size.x, 0.0)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(size.x, 0.0)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(-size.x, -size.y)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(size.x, -size.y)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(-size.x, size.y)).a);
        max_alpha = max(max_alpha, texture(TEXTURE, UV + vec2(size.x, size.y)).a);

        COLOR = mix(sprite_color, line_color, max_alpha - alpha);
    }
}