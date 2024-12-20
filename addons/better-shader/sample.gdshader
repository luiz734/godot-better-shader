shader_type canvas_item;

void vertex() {

}

void fragment() {
    COLOR = texture(TEXTURE, UV);
    COLOR.rg = fract(UV + vec2(sin(TIME), cos(TIME)));
}