shader_type canvas_item;

uniform float speed = 0.5;
uniform float fade : hint_range(0, 1.0);
uniform int num = 2;

uniform float time = 0;

vec4 get_color(float diff) {
	if (diff < fade) {
		return vec4((1.0 - (diff / fade)), 0, 0, 1);
	} else if (fade > (1.0 - diff)) {
		return vec4((1.0 - ((1.0 - diff) / fade)), 0, 0, 1);
	}
	
	return vec4(0,0,0,1);
}

void fragment() {
	float val = mod(time * speed, 1);
	float diff = mod(UV.x - val, 1);
	
	vec4 final_color = vec4(0, 0, 0, 0);
	float add = 1.0 / float(num);
	for(float i = 0.0; i < float(num); i++) {
		final_color += get_color(mod(diff + add * i, 1));
	}
	final_color.r *= (1.0 - mod(abs(UV.y - 0.5), 1));
	final_color.a = final_color.r;
	
	COLOR *= final_color;
}