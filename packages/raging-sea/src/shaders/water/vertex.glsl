uniform float uTime;
uniform float uBigWavesElevation;
uniform vec2 uBigWavesFrequency;
uniform float uBigWavesSpeed;

varying float vElevation;

void main() {
    vec4 modelPosition = modelMatrix * vec4(position, 1.0);

    // Elevation
    float elevationX = sin(modelPosition.x * uBigWavesFrequency.x + uTime * uBigWavesSpeed);
    float elevationZ = sin(modelPosition.z * uBigWavesFrequency.y + uTime * uBigWavesSpeed);
    float elevation = elevationX * elevationZ * uBigWavesElevation;
    modelPosition.y += elevation;

    vec4 viewPosition = viewMatrix * modelPosition;
    vec4 projectedPosition = projectionMatrix * viewPosition;
    gl_Position = projectedPosition;

    // Varyings
    vElevation = elevation;
}