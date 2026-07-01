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
    gl_FragColor = vec4(strength, strength, strength, 1.0);

    #include <colorspace_fragment>
}