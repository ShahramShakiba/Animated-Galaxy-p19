varying vec3 vColor; 

void main() {
  //==== Light point
  float strength = distance(gl_PointCoord, vec2(0.5)); // 04
  strength = 1.0 - strength;
  strength = pow(strength, 10.0); 

  //==== Final Color
  vec3 mixColor = mix(vec3(0.0), vColor, strength); // 06

  gl_FragColor = vec4(mixColor, 1.0);
  
  #include <colorspace_fragment>;
}




/* *********  Draw disc(circle) shape for particles
  
      float strength = distance(gl_PointCoord, vec2(0.5));
      strength = step(0.5, strength);
      strength = 1.0 - strength;
``````````````````````````````````````````````````````````````

    - if you want the "uv" of a vertex you don't have to send varying from "vertex.glsl" to "fragment.glsl".

  * gl_PointCoord 
    - is a built-in GLSL variable available in the fragment-shader. 
    - It gives the coordinates of the current fragment within a point primitive. 
    - The coordinates range from 0.0 to 1.0 in both the x and y directions, where (0.0, 0.0) is the bottom-left corner and (1.0, 1.0) is the top-right corner of the point.

- we can not send the "uv" as a varying because each vertex is a particle but we can use "gl_PointCoord"  


* float strength = distance(gl_PointCoord, vec2(0.5));

  ? vec2(0.5, 0.5) represents the center of the point.

  ? distance(gl_PointCoord, vec2(0.5)) 
    - calculates distance between two points - the distance from the current fragment to the center of the point.

  - strength will be 0.0 at the center of the point and increase as you move towards the edge.  


* strength = step(0.5, strength);

- to assign a value of 0.0 for fragments inside the circle and 1.0 for fragments outside.

- 0.0 if the fragment is within the circle (radius 0.5) and 1.0 if outside 
- it's looks like a black circle in the center with white edges.



* strength = 1.0 - strength;

- Inverts the value, making fragments inside the circle 1.0 (visible) and outside 0.0 (invisible).
- so it's like you can see a white circle  */



/* *********  Diffuse point - it's better and nicer from disc

  float strength = distance(gl_PointCoord, vec2(0.5));
  strength *= 2.0; // get to 1 faster
  strength = 1.0 - strength;
``````````````````````````````````````````````````````````

? strength *= 2.0;
  - By scaling the distance by 2, the strength value transitions from 1 to 0 more rapidly as you move away from the center to the edges. 
  
Visual Effect :
- This faster transition to 1 means that the fragments closer to the center will have higher "strength" values, and the falloff towards 0 will be more pronounced as you move towards the edges of the point.

- This results in a sharper gradient from the center to the edge, creating a more defined and visually pleasing effect.  */



/* *********  Light point - it's better and nicer from disc and diffuse

? strength = pow(strength, 10.0); 
  - control how much you push the value close to 0 
  - if you use less power you get less effect
  - if you use bigger power you get more effect

Visual Effect :
- Sharper Contrast: 
  This operation creates a sharper contrast, making the central region of the point brighter and the falloff towards the edges more dramatic.

- Focused Highlight: 
  It effectively makes the central highlight much more pronounced, giving a visual effect that appears more focused and intense towards the center and rapidly diminishing towards the edges. */



/* *********  Another way instead of using "mixColor" - Easier way

in index.js 
  ShaderMaterial part : 
    - add;   transparent: true,


  Then here:

  gl_FragColor = vec4(vColor, strength);  */
  