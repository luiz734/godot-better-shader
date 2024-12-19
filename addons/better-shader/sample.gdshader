shader_type canvas_item;

void vertex() {

}

void fragment() {
    COLOR = texture(TEXTURE, UV);
    COLOR.rg = UV;
}