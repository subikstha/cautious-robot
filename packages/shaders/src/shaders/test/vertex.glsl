uniform mat4 projectionMatrix; // will transform the coordinates into the clip space coordinates
uniform mat4 viewMatrix; // applies transformation relative to the camera(position, rotation, field of view, near, far)
uniform mat4 modelMatrix; // modelmatrix applies transformation relative to the Mesh(position, rotation, scale)
uniform vec2 uFrequency;
uniform float uTime;
// This is the value that was provided in the BufferGeometry in JS
attribute vec3 position; // It is the data that changes with each vertex
attribute float aRandom;
attribute vec2 uv;

varying vec2 vUv;
varying float vElevation;
// varying float vRandom;

void main()
{
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    float elevation = sin(modelPosition.x * uFrequency.x - uTime) * .1;
    elevation += sin(modelPosition.y * uFrequency.x - uTime) * .1;
    modelPosition.z += elevation;
    
    // modelPosition.z += aRandom * 0.1;
    vec4 viewPosition = viewMatrix * modelPosition;
    // viewPosition.x -= 2.0;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    vUv = uv;
    vElevation = elevation;
    // vRandom = aRandom;
}