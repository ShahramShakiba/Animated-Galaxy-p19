





//===================================================
/* "It is not an actual project; therefore,
I rely on comments to assess the code." */
//===================================================
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import * as THREE from 'three';
import { debugGUI } from './debugGUI';
import vertexGalaxy from './Shaders/galaxy/vertex.glsl';
import fragmentGalaxy from './Shaders/galaxy/fragment.glsl';

const canvas = document.querySelector('canvas.webgl');
const scene = new THREE.Scene();

let width = window.innerWidth;
let height = window.innerHeight;
const clock = new THREE.Clock();

//=== Galaxy
const parameters = {
  count: 100000,
  size: 0.005,
  radius: 5,
  branches: 3,
  spin: 1,
  randomness: 0.5,
  randomnessPower: 3,
  insideColor: '#ff6030',
  outsideColor: '#1b3984',
};

let geometry = null;
let material = null;
let points = null;

const generateGalaxy = () => {
  if (points !== null) {
    geometry.dispose();
    material.dispose();
    scene.remove(points);
  }

  //========== Geometry
  geometry = new THREE.BufferGeometry();

  const positions = new Float32Array(parameters.count * 3);
  const colors = new Float32Array(parameters.count * 3);
  const scales = new Float32Array(parameters.count * 1); // 1 randomValue per vertex
  const randomness = new Float32Array(parameters.count * 3);

  const insideColor = new THREE.Color(parameters.insideColor);
  const outsideColor = new THREE.Color(parameters.outsideColor);

  for (let i = 0; i < parameters.count; i++) {
    const i3 = i * 3;

    //=== Position
    const radius = Math.random() * parameters.radius;

    const branchAngle =
      ((i % parameters.branches) / parameters.branches) * Math.PI * 2;

    positions[i3] = Math.cos(branchAngle) * radius;
    positions[i3 + 1] = 0;
    positions[i3 + 2] = Math.sin(branchAngle) * radius;

    //=== Randomness
    const randomX =
      Math.pow(Math.random(), parameters.randomnessPower) *
      (Math.random() < 0.5 ? 1 : -1) *
      parameters.randomness *
      radius;

    const randomY =
      Math.pow(Math.random(), parameters.randomnessPower) *
      (Math.random() < 0.5 ? 1 : -1) *
      parameters.randomness *
      radius;

    const randomZ =
      Math.pow(Math.random(), parameters.randomnessPower) *
      (Math.random() < 0.5 ? 1 : -1) *
      parameters.randomness *
      radius;

    randomness[i3] = randomX;
    randomness[i3 + 1] = randomY;
    randomness[i3 + 2] = randomZ;

    //===== Color
    const mixedColor = insideColor.clone();
    mixedColor.lerp(outsideColor, radius / parameters.radius);

    colors[i3] = mixedColor.r;
    colors[i3 + 1] = mixedColor.g;
    colors[i3 + 2] = mixedColor.b;

    //===== Scale
    scales[i] = Math.random();
  }

  geometry.setAttribute('position', new THREE.BufferAttribute(positions, 3));
  geometry.setAttribute('color', new THREE.BufferAttribute(colors, 3));
  geometry.setAttribute('aScale', new THREE.BufferAttribute(scales, 1));
  geometry.setAttribute(
    'aRandomness',
    new THREE.BufferAttribute(randomness, 3)
  );

  //============== Material
  material = new THREE.ShaderMaterial({
    depthWrite: false,
    blending: THREE.AdditiveBlending,
    vertexColors: true,

    vertexShader: vertexGalaxy,
    fragmentShader: fragmentGalaxy,

    uniforms: {
      uSize: { value: 10 * renderer.getPixelRatio() },
      uTime: { value: 0 },
    },
  });

  //============== Point
  points = new THREE.Points(geometry, material);
  scene.add(points);
};

debugGUI(parameters, generateGalaxy);

//=================== Camera =======================
const camera = new THREE.PerspectiveCamera(75, width / height, 0.1, 100);
camera.position.set(3, 3, 3);
scene.add(camera);

//============== Orbit Controls ====================
const controls = new OrbitControls(camera, canvas);
controls.enableDamping = true;

//================== Renderer ======================
const renderer = new THREE.WebGLRenderer({
  canvas: canvas,
  antialias: false,
});
renderer.setSize(width, height);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

// To getPixelRatio in uniforms we call it here
generateGalaxy();

//============== Resize Listener ===================
let resizeTimeout;

const onWindowResize = () => {
  clearTimeout(resizeTimeout);

  resizeTimeout = setTimeout(() => {
    width = window.innerWidth;
    height = window.innerHeight;

    camera.aspect = width / height;
    camera.updateProjectionMatrix();

    renderer.setSize(width, height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 1.5));
  }, 200);
};

window.addEventListener('resize', onWindowResize);

//================= Animate ======================
const tick = () => {
  const elapsedTime = clock.getElapsedTime();

  material.uniforms.uTime.value = elapsedTime;

  controls.update();
  renderer.render(scene, camera);
  window.requestAnimationFrame(tick);
};

tick();

/* **************  branchAngle
 - calculates the angle for positioning branches around a central point (like a tree trunk) in a circular manner.

 ? i % parameters.branches: 
     - Computes the remainder when i is divided by the total number of branches (parameters.branches). This ensures the value of i cycles through a sequence from 0 to parameters.branches - 1.

 ? ((i % parameters.branches) / parameters.branches): 
     - Normalizes the remainder to a fraction between 0 and 1 by dividing it by parameters.branches.

 ? * Math.PI * 2: 
     - Converts the normalized fraction into an angle in radians. multiplying by 2 converts it to a full circle (2π radians or 360 degrees) */

/* **************  Math.pow
  ? Math.pow(Math.random(), parameters.randomnessPower): 
    - Raises the random number to the power of parameters.randomnessPower, adjusting how "spread out" the values are. 

  ? Math.random() < 0.5 ? 1 : -1: 
    - Randomly makes the value positive or negative.
  
  ? * parameters.randomness: 
    - Scales the value by a factor defined by parameters.randomness.

  ? * radius: 
    - Further scales the value by the given radius.  */

/* ***********  mixedColor.lerp(outsideColor, radius / parameters.radius);
  ? insideColor.clone(): 
    - This method creates a new instance (clone) of the insideColor object

  ? mixedColor.lerp(outsideColor, t): 
    - This function interpolates (blends) between mixedColor and outsideColor.

  ? radius / parameters.radius: 
    - This calculates the blending factor t, which determines how much of each color to mix. It is the ratio of radius to parameters.radius.  */
