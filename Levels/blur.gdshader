shader_type canvas_item;

uniform float blur_amount : hint_range(0.0, 10.0) = 0.0;

void fragment() {
    vec4 sum = vec4(0.0);
    vec2 pixel_size = 1.0 / vec2(textureSize(TEXTURE, 0));

    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * pixel_size * blur_amount;
            sum += texture(TEXTURE, UV + offset);
        }
    }

    COLOR = sum / 9.0;
}