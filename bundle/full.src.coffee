###
# `Earth extends Globe`

A `Globe` provides an `Object3D` whos `add` is overridden to place the
child Object3D at some lat/lon on the surface of a conceptual globe.
The child is oriented so the Z axis points out from the globe, the Y axis
points to the north pole, and the X axis is orthagonal, pointing East.
###

class window.Earth extends S3age.Extras.Globe
	###
	In the Constructor, we'll add a new sphere with a texture of the Earth.
	Texture from NASA - 
	###
	constructor: ->
		S3age.Extras.Globe.call @
		sphere = new THREE.SphereGeometry @radius, 64, 32
		map = THREE.ImageUtils.loadTexture "app/textures/earth_day_4096.jpg"
		ground = new THREE.MeshBasicMaterial { map }
		surface = new THREE.Mesh sphere, ground
		@add surface

###
# Quake Marker

Marker to show the magnitude and speed of the quake.
The heights array is a list of numbers for the "canonical"
seismograph icon. It will be scaled to correspond to magnitude.
###
heights = [0, 1, -0.75, 5, -1, 1.5, -0.75, 0.3, 0]

###
To improve memory performance, we only create on instance
of the geometry and color.
###
markerGeo = new THREE.Geometry()
markerGeo.vertices = (new THREE.Vector3 x, y, 0 for y, x in heights)
dot = new THREE.LineBasicMaterial { color: 0xff0000, lineWidth: 2 }
circleGeo = new THREE.CircleGeometry 1, 128

class window.Quake extends THREE.Object3D
	constructor: (id, quake)->
		THREE.Object3D.call @

		@id = "quake_#{id}"

		@lat = quake.lat
		@lon = quake.lon
		@mag = quake.mag
		@depth = quake.depth

		Object.defineProperty @, 'color',
			get: ->
				hue = Math.lerp quake.mag, 0, 9, 0.5, 0
				color = new THREE.Color()
				color.setHSL hue, 0.5, 0.5
				color

		###
		Each class gets its own marker, an instance of `THREE.Line`.
		All the lines share the geometry and 
		###
		marker = new THREE.Line markerGeo, dot
		marker.scale.x = 0.005
		marker.scale.y = 0.001 * @mag
		@add marker

		###
		The wave is simply a circle.
		The color for the wave on the surface of the earth is tied
		to the magnitude of the earthquake - darker purple is weaker quake.
		###
		material = new THREE.LineBasicMaterial { color: @color }
		wave = new THREE.Line circleGeo, material
		@add wave

		###
		Changing the `travel` property on the marker has side effects.
		The anonymous function binds to the ctor instance, and wraps a
		private local variable.
		###
		Object.defineProperty @, 'travel', do =>
			_travel = 0
			get: ->
				_travel
			set: (val)=>
				# Contrain value between 0 and one-tenth the magnitude.
				val = val % (0.1 * @mag)
				# Quick check to prevent val from being zero, or bad
				# divisions occur.
				val = if val is 0 then 0.0001 else val

				# The XY-plane size of the circle scales along the
				# radius of the chord through the sphere at some distance
				# from the sphere center.
				wave.scale.y = wave.scale.x = Math.sin val
				# The wave center moves along the Z axis
				# (towards the center of the Earth)
				wave.position.z = Math.cos(val) - 1
				# Store the underlying value.
				_travel = val
		@travel = 0
		@

	update: (clock)->
		@travel += 0.001

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

###
Build a new Earth object. Add each of the quakes with each type of marker.
###
earth = new Earth()
for id, quake of quakes
	earth.addMarker new Pin id, quake

###
A S3age manages a variety of details of the 3D scene. In this case,
some ambient light, the Earth with Quakes, and a Sphere control.
###
new S3age "#container",
	camera: position: [-3, 3, 4], lookAt: [0, 0, 0]
	scene:
		lights: [ new THREE.AmbientLight 0xdddddd ]
		children: [ earth ]
	controls: THREE.OrbitControls
	testing: true
	expose: true
