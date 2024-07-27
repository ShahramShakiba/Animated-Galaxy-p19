uniform float uSize; // 01

attribute float aScale; // 02

void main() {
  vec4 modelPosition = modelMatrix * vec4(position, 1.0);
  vec4 viewPosition = viewMatrix * modelPosition;
  vec4 projectionPosition = projectionMatrix * viewPosition;

  gl_PointSize = uSize * aScale;
  gl_PointSize *= ( 1.0 / - viewPosition.z ); 

  gl_Position = projectionPosition;
}




/* *********  gl_PointSize *= ( scale / - mvPosition.z ) - sizeAttenuation

? gl_PointSize *= ( 1.0 / - viewPosition.z ) : 
  - sizeAttenuation

*/


/* *********  Draw Shape for our particles


*/

/* *********  


*/