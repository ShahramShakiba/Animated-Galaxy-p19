varying vec3 vColor; 

void main() {
  //==== Diffuse point 
    float strength = distance(gl_PointCoord, vec2(0.5)); 
  strength *= 2.0;
  strength = 1.0 - strength; 

  //==== Final Color
  vec3 mixColor = mix(vec3(0.0), vColor, strength); 

  gl_FragColor = vec4(mixColor, 1.0);
  
  #include <colorspace_fragment>;
}

