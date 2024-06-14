shader_type canvas_item;

uniform float hit_opacity = 0;

void fragment() {
	COLOR.rgb = texture(TEXTURE, UV).rgb * (1.0 - hit_opacity) + vec3(2,1,1) * hit_opacity; //interpolates between the original sprite's color and the color white depending on the value of hit_opacity
	COLOR.a = texture(TEXTURE, UV).a ; //copies the original sprite's alpha values
}