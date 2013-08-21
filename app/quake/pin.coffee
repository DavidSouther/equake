###
# Pin marker

One of two marker types we build for this. This is a ball at the end
of a tube, to create the quarkboard Pin concept.
###
geom = new THREE.SphereGeometry 1, 20, 20

class window.Pin extends THREE.Object3D
	constructor: (@lat, @lon, @mag)->
		super()
		###
		Color is some value between black and blue. Bluer is stronger quake.
		###
		color = Math.lerp @mag, 0, 10, 0x000000, 0x0000ff
		material = new THREE.MeshBasicMaterial { color }
		ball = new THREE.Mesh geom, material

		###
		Size of the pin. Values chosen by experimentation.
		###
		size = Math.lerp @mag, 0, 10, 0.01, 0.05
		ball.position.z = size / 2
		ball.scale.multiplyScalar size
		@add ball
