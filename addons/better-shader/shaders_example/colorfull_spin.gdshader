shader_type canvas_item;


void fragment() {
    COLOR = texture(TEXTURE, UV);
    vec2 uv = UV - vec2(0.5);
    COLOR.rg = fract(uv + 0.5 *  vec2(sin(TIME), cos(TIME)));
}