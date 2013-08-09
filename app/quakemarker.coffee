deg = Math.PI / 180
s1 = 179 * deg
s2 = 89 * deg
dot = new THREE.LineBasicMaterial { color: 0xff0000, lineWidth: 2 }

heights = [0, 1, -0.75, 5, -1, 1.5, -0.75, 0.3, 0]

marker = new THREE.Geometry()
marker.vertices = (new THREE.Vector3 i, y for y, i in heights)

window.QuakeMarker = (lat, lon, mag = 5)->
	THREE.Object3D.call @, [].slice.call arguments, 0
	@rotation.set lat, lon, 0

	center = new THREE.Object3D()
	center.position.x = 1.001
	center.rotation.y = Math.PI / 2
	center.up.set 0, 1, 0

	display = new THREE.Line marker, dot
	display.scale.set 0.005, 0.001 * mag, 0.01

	center.add display
	@add center

	@

QuakeMarker:: = Object.create THREE.Object3D::
