uniform float uSize; // 01
uniform float uTime; // 07

attribute float aScale; // 02
attribute vec3 aRandomness; // 09

varying vec3 vColor; // 05

void main() {
  vec4 modelPosition = modelMatrix * vec4(position, 1.0);

  //=== Spin - 08
  float angle = atan(modelPosition.x, modelPosition.z);
  float distanceToCenter = length(modelPosition.xz);

  float angleOffset = (1.0 / distanceToCenter) * uTime * 0.2;
  angle += angleOffset;

  modelPosition.x = cos(angle) * distanceToCenter;
  modelPosition.z = sin(angle) * distanceToCenter;

  //=== Randomness
  modelPosition.xyz += aRandomness;
  
  vec4 viewPosition = viewMatrix * modelPosition;
  vec4 projectionPosition = projectionMatrix * viewPosition;

  gl_PointSize = uSize * aScale;
  gl_PointSize *= ( 1.0 / - viewPosition.z ); // 03

  vColor = color;

  gl_Position = projectionPosition;
}


/* *********  gl_PointSize = uSize * aScale;
- Sets the initial point(vertex) size using the base-size (uSize) and the scale-factor (aScale)  */



/* *************  gl_PointSize *= ( scale / - mvPosition.z ) 
  - set "sizeAttenuation"

  - The code ensures that the size of points rendered by the shader changes based on their distance from the camera, creating a depth effect. 
  - Closer points will appear larger, and farther points will appear smaller, simulating a perspective view. 
  - This adjustment is crucial for creating a realistic sense of depth in 3D graphics.


* gl_PointSize *= ( 1.0 / - viewPosition.z ) : 
  - sizeAttenuation : 
    This code adjusts the size of a point in a 3D graphics context


? gl_PointSize  
  - A built-in variable in WebGL/OpenGL that specifies the diameter قطر of a point to be rasterized(convert into pixels) on the screen.
  
? mvPosition.z  or  viewPosition.z
  - model view position
  - for us the mvPosition is;  viewPosition = viewMatrix * modelPosition;

  - viewPosition.z: The z coordinate of viewPosition represents the depth of the vertex in view space (how far it is from the camera).

? -mvPosition.z  or  - viewPosition.z
  - Negates the z-coordinate because depth values are usually negative in view space.
  - The negative sign ensures the depth value is positive since in view space, z is usually negative in front of the camera.

? scale / -mvPosition.z  or  1.0 / - viewPosition.z
  - This scales the point size based on its depth. 
  - Closer points appear larger, and farther points appear smaller. 
  - The scale factor is a user-defined parameter that controls how much the size changes with depth.

  - This creates a value that decreases as the vertex gets farther from the camera, causing distant points to appear smaller.  */



/* *********   Spin Part
  ? atan() stands for arc-tangent
    - Provide you "angle"


  * float angleOffset = (1.0 / distanceToCenter) * uTime * 0.2;

    ? 1.0 / distanceToCenter 
      - only distanceToCenter : 
        the points around the center spin slowly and vice versa.

      - therefore, we divide it by 1 so the outer-points spin slowly and inner-points spin faster


    ? * uTime * 0.2 
      - offset will bigger with the time pass through and since it's too fast we decrease the speed of the spin */


