uniform mat4 projectionMatrix; // will transform the coordinates into the clip space coordinates
uniform mat4 viewMatrix; // applies transformation relative to the camera(position, rotation, field of view, near, far)
uniform mat4 modelMatrix; // modelmatrix applies transformation relative to the Mesh(position, rotation, scale)
uniform vec2 uFrequency;
uniform float uTime;
// This is the value that was provided in the BufferGeometry in JS
attribute vec3 position; // It is the data that changes with each vertex
attribute float aRandom;

// varying float vRandom;

void main()
{
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);
    modelPosition.z += sin(modelPosition.x * uFrequency.x - uTime) * .1;
    modelPosition.z += sin(modelPosition.y * uFrequency.y - uTime) * .1;
    // modelPosition.z += aRandom * 0.1;
    vec4 viewPosition = viewMatrix * modelPosition;
    // viewPosition.x -= 2.0;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    // vRandom = aRandom;
}