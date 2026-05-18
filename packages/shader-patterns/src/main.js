import * as THREE from 'three'
import GUI from 'lil-gui'

const gui = new GUI()
const params = { rotationSpeed: 0.015 }

const scene = new THREE.Scene()
scene.background = new THREE.Color(0x16213e)

const camera = new THREE.PerspectiveCamera(
  50,
  window.innerWidth / window.innerHeight,
  0.1,
  100
)
camera.position.z = 3

const geometry = new THREE.IcosahedronGeometry(0.85, 0)
const material = new THREE.MeshNormalMaterial({ flatShading: true })
const mesh = new THREE.Mesh(geometry, material)
scene.add(mesh)

const renderer = new THREE.WebGLRenderer({ antialias: true })
renderer.setSize(window.innerWidth, window.innerHeight)
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
document.body.appendChild(renderer.domElement)
document.body.style.margin = '0'

gui.add(params, 'rotationSpeed', 0, 0.05, 0.001).name('Rotation speed')

function onResize() {
  camera.aspect = window.innerWidth / window.innerHeight
  camera.updateProjectionMatrix()
  renderer.setSize(window.innerWidth, window.innerHeight)
}
window.addEventListener('resize', onResize)

function tick() {
  mesh.rotation.x += params.rotationSpeed
  mesh.rotation.y += params.rotationSpeed * 0.9
  renderer.render(scene, camera)
  requestAnimationFrame(tick)
}
tick()
