void main() {
  //=== Draw a disc(circle) for particles
  float strength = distance(gl_PointCoord, vec2(0.5));
  strength = step(0.5, strength);
  strength = 1.0 - strength;

  gl_FragColor = vec4(vec3(strength), 1.0);
  
  #include <colorspace_fragment>;
}




/* *********  gl_PointCoord
    - if you want the "uv" of a vertex you don't have to send varying from "vertex.glsl" to "fragment.glsl".

  * gl_PointCoord 
    - is a built-in GLSL variable available in the fragment-shader. 
    - It gives the coordinates of the current fragment within a point primitive. 
    - The coordinates range from 0.0 to 1.0 in both the x and y directions, where (0.0, 0.0) is the bottom-left corner and (1.0, 1.0) is the top-right corner of the point.

- we can not send the "uv" as a varying because each vertex is a particle but we can use "gl_PointCoord"  */



/* *********   float strength = distance(gl_PointCoord, vec2(0.5));

  ? vec2(0.5, 0.5) represents the center of the point.

  ? distance(gl_PointCoord, vec2(0.5)) 
    - calculates distance between two points - the distance from the current fragment to the center of the point.

  - strength will be 0.0 at the center of the point and increase as you move towards the edge.  */



/* *********  strength = step(0.5, strength);

- to assign a value of 0.0 for fragments inside the circle and 1.0 for fragments outside.

- 0.0 if the fragment is within the circle (radius 0.5) and 1.0 if outside 
- it's looks like a black circle in the center with white edges  */



/* *********  strength = 1.0 - strength;

- Inverts the value, making fragments inside the circle 1.0 (visible) and outside 0.0 (invisible).

- so it's like you can see a white circle  */



/* *********  


*/



/* *********  


*/