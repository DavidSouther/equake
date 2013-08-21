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
