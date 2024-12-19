shader_type canvas_item;

void vertex() {

}

void fragment() {
    COLOR = vec4(UV, 1.0, 1.0);
    COLOR.a = UV.x;
}