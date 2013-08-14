dot = new THREE.LineBasicMaterial { color: 0xff0000, lineWidth: 2 }

heights = [0, 1, -0.75, 5, -1, 1.5, -0.75, 0.3, 0]

markerGeo = new THREE.Geometry()
markerGeo.vertices = (new THREE.Vector3 i, y for y, i in heights)
circleGeo = new THREE.CircleGeometry 1, 128

window.Quake = (id, quake)->
	THREE.Object3D.apply @, [].slice.call arguments, 2
	@id = "quake_#{id}"

	@lat = quake.lat
	@lon = quake.lon
	@mag = quake.mag

	marker = new THREE.Line markerGeo, dot
	marker.scale.x = 0.005
	marker.scale.y = 0.001 * @mag
	@add marker

	material = new THREE.LineBasicMaterial {color: 0xff00ff, opacity: 0.5}
	wave = new THREE.Line circleGeo, material
	@add wave

	Object.defineProperty @, 'travel', do =>
		_travel = 0
		get: ->
			_travel
		set: (val)=>
			val = val % (0.1 * @mag)
			val = if val is 0 then 0.001 else val
			wave.scale.y = wave.scale.x = Math.sin val
			wave.position.z = Math.cos(val) - 1
			_travel = val
	@travel = 0
	@

Quake:: = Object.create THREE.Object3D::
Quake::update = (clock)->
	@travel = (@travel + 0.001) % Math.PI