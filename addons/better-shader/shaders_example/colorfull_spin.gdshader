shader_type canvas_item;

uniform sampler2D noise: repeat_enable;

vec3 hsv_to_rgb(vec3 hsv) {
    float h = hsv.x; // Hue: 0-1
    float s = hsv.y; // Saturation: 0-1
    float v = hsv.z; // Value: 0-1

    float c = v * s; // Chroma
    float x = c * (1.0 - abs(mod(h * 6.0, 2.0) - 1.0));
    float m = v - c;

    vec3 rgb;

    if (h < 1.0 / 6.0) {
        rgb = vec3(c, x, 0.0);
    } else if (h < 2.0 / 6.0) {
        rgb = vec3(x, c, 0.0);
    } else if (h < 3.0 / 6.0) {
        rgb = vec3(0.0, c, x);
    } else if (h < 4.0 / 6.0) {
        rgb = vec3(0.0, x, c);
    } else if (h < 5.0 / 6.0) {
        rgb = vec3(x, 0.0, c);
    } else {
        rgb = vec3(c, 0.0, x);
    }

    return rgb + vec3(m);
}

void fragment() {
    vec2 uv = UV;

    // goes 0.0 -> 1.0 -> 0.0 -> ....
    float nsin = sin(TIME) * 0.5 + 0.5;
    // goes 0.0 -> 1.0 and turn back to 0.0
    float nt = fract(TIME * 0.5);
    // goes 2,3,4,5,2,3,4,5...
    float t = floor(fract(TIME*(1.0/4.0)) * 4.0) + 2.0;

    // move right or left
    if (int(t * uv.y) % 2 == 0) {
        uv.x *= -1.0;
    }

    // move
    uv.x = fract(uv.x - TIME*(1.0/t));

    // Uncoment for interesting effect
    uv *= t;

    // colors
    float n_cols = floor(fract(TIME * (2.0/10.0)) * 10.0) + 2.0;
    vec2 sample_uv = vec2(floor(uv.y), floor(uv.x) ) / vec2(n_cols);
    float h = fract(10.0 * texture(noise, sample_uv).r);
    vec4 color = vec4(hsv_to_rgb(vec3(h, 1.0, 1.0)), 1.0);
    uv = fract(uv);


    // rotation
    float angle = -nt * (PI * 2.0);
    uv -= vec2(0.5);
    vec2 rotated_uv = uv;
    rotated_uv.x = uv.x * cos(angle) - uv.y * sin(angle);
    rotated_uv.y = uv.x * sin(angle) + uv.y * cos(angle);
    uv = rotated_uv;
    uv += vec2(0.5);

    COLOR = texture(TEXTURE, uv);
    COLOR = mix(texture(TEXTURE, uv), color, 0.5);
}