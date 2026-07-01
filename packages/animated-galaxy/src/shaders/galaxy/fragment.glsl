varying vec3 vColor;
void main() {
    // float strength = step(distance(gl_PointCoord, vec2(0.5)), 0.5);

    // Diffuse
    // float strength = distance(gl_PointCoord, vec2(0.5));
    // strength *= 2.0;
    // strength = 1.0 - strength;

    // Point Light
    float strength = distance(gl_PointCoord, vec2(0.5));
    strength = 1.0 - strength;
    strength = pow(strength, 10.0);

    vec3 color = mix(vec3(0.0), vColor, strength); // Mix from black to the vColor depending on the strength
    gl_FragColor = vec4(color, 1.0);

    #include <colorspace_fragment>
}