deg = Math.PI / 180
s1 = 179 * deg
s2 = 89 * deg
marker = new THREE.SphereGeometry 1.001, 4, 4, s1, deg, s2, deg
dot = new THREE.MeshBasicMaterial { transparent: true, wireframe: true, color: 0xff0000 }

window.QuakeMarker = (lat, lon, mag = 5)->
	THREE.Object3D.call @, [].slice.call arguments, 0
	display = new THREE.Mesh marker, dot
	display.rotation.set lat, lon, 0
	@add display
	@

QuakeMarker:: = Object.create THREE.Object3D::
