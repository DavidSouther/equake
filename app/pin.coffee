###
# Pin marker

One of two marker types we build for this. This is a ball at the end
of a tube, to create the quarkboard Pin concept.
###
geo =
	head: new THREE.CircleGeometry 1, 64
	line: do ->
		g = new THREE.Geometry()
		g.vertices.push new THREE.Vector3()
		g.vertices.push new THREE.Vector3(0, 0, 1)
		g

class window.Pin extends Quake
	constructor: (id, quake)->
		Quake.apply @, [].slice.call arguments, 0
		###
		Color is some value between black and blue. Bluer is stronger quake.
		###
		color = @color
		material = new THREE.MeshBasicMaterial { color, side: THREE.DoubleSide }
		ball = new THREE.Mesh geo.head, material

		height = Math.lerp @depth, 0, 100, 0, 0.1
		ball.position.z = height

		###
		Size of the pin. Values chosen by experimentation.
		###
		size = Math.lerp @mag, 0, 10, 0.01, 0.05
		ball.scale.multiplyScalar size
		@add ball

		lineMaterial = new THREE.LineBasicMaterial {color, linewidth: 1}
		line = new THREE.Line(geo.line, lineMaterial)
		line.scale.z = height || 0.001
		@add line
