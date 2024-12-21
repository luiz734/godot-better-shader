shader_type canvas_item;


void fragment() {
    vec4 color = vec4(UV, 1.0, step(1.0, COLOR.a));
    COLOR = mix(texture(TEXTURE, UV), color, 0.5);

}