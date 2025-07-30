shader_type canvas_item;

void fragment() {
	float x = ((UV.x - 0.5) * 2.0);
	float y = ((UV.y - 0.5) * 2.0);
	if(pow(x,2) + pow(y,2) > 1.0){
		COLOR.a = 0.0;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
