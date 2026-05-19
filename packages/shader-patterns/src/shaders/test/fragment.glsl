varying vec2 vUv;
void main()
{
    // Pattern 3
    float strength = vUv.x;
    // gl_FragColor = vec4(0.5, 0.0, 1.0, 1.0);
    gl_FragColor = vec4(strength, strength, strength, 1.0);
}