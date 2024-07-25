import GUI from 'lil-gui';

export const debugGUI = (parameters, generateGalaxy) => {
  const gui = new GUI();

  gui
    .add(parameters, 'count')
    .min(100)
    .max(1000000)
    .step(100)
    .onFinishChange(generateGalaxy);

  gui
    .add(parameters, 'radius')
    .min(0.01)
    .max(20)
    .step(0.01)
    .onFinishChange(generateGalaxy);

  gui
    .add(parameters, 'branches')
    .min(2)
    .max(20)
    .step(1)
    .onFinishChange(generateGalaxy);

  gui
    .add(parameters, 'randomness')
    .min(0)
    .max(2)
    .step(0.001)
    .onFinishChange(generateGalaxy);

  gui
    .add(parameters, 'randomnessPower')
    .min(1)
    .max(10)
    .step(0.001)
    .onFinishChange(generateGalaxy);

  gui.addColor(parameters, 'insideColor').onFinishChange(generateGalaxy);
  gui.addColor(parameters, 'outsideColor').onFinishChange(generateGalaxy);
};
