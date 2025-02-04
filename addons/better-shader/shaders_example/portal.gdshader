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
    uv.y *= TEXTURE_PIXEL_SIZE.x/TEXTURE_PIXEL_SIZE.y;
    uv.y += (TEXTURE_PIXEL_SIZE.x-TEXTURE_PIXEL_SIZE.y)/2.0;
    uv -= vec2(0.5);
    
    int n_rings = 20;
    uv*=float(n_rings);
    float dist = distance(uv, vec2(0.0));
    dist = fract(dist);
    float ring = floor(dist);
    
    float angle_a = atan(uv.y, uv.x);
    angle_a += PI;
    angle_a /= 2.0*PI;
    
    float angle_b = -angle_a;
    
    float thickness = 0.7;
    float circle_mask = step(dist, thickness) * (1.0 - step(dist, 0.0));
    float spin_speed = 0.3;
    float min_slice = 0.0;
    float max_slice = 0.2;
    
    float spread = 0.2;
    spread += 0.1 * cos(TIME);
    
    float norm_cos_a = (cos(TIME) + 1.0) * 0.5;
    //float slice_a = min_slice + 1.0 * (max_slice - min_slice);
    float slice_a = 0.0;
    slice_a += spread * (cos(2.0 * PI * (fract(dist-(1.0-thickness)))));
    angle_a = fract(angle_a+TIME*0.2);
    
    float norm_cos_b = (cos(TIME) + 1.0) * 0.5;
    float slice_b = 0.0;
    slice_b += spread * (cos(2.0 * PI * (fract(dist-(1.0-thickness)))));
    angle_b = fract(angle_b-TIME*0.2);
    
    float mask_a = step(angle_a, slice_a);
    float mask_b = step(angle_b, slice_b);
    circle_mask = mask_a + mask_b;
   
    
    
    COLOR = vec4(1.0, 1.0, 1.0, 1.0) * circle_mask;
}