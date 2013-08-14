window.Earth = Earth = ->
	THREE.Object3D.call @, [].slice.call arguments, 0
	@add @tilted = new THREE.Object3D()
	@rotation.z = toRad 23.4

	@speed = rotation: 0.001

	sphere = new THREE.SphereGeometry 1, 64, 32
	map = THREE.ImageUtils.loadTexture "app/textures/earth_day_4096.jpg"
	ground = new THREE.MeshBasicMaterial { map }
	surface = new THREE.Mesh sphere, ground
	@tilted.add surface

	latlon = new THREE.Mesh sphere, new THREE.MeshBasicMaterial {color: 0xe3e3e3, wireframe: true}
	latlon.scale.multiplyScalar 1.01
	@tilted.add latlon

	@tilted.add new THREE.AxisHelper 1.5
	@tilted.add @quakes = new THREE.Object3D()
	@quakes.id = "earth_quakes"
	@

Earth:: = Object.create THREE.Object3D::

Earth::update = (clock)->
	# @tilted.rotation.y += @speed.rotation
	c.update? clock for c in @tilt.children

toRad = (deg)-> deg * Math.PI / 180
Earth::correct = (lat, lon)-> [toRad(lat), toRad(lon)]

Earth::quake = (quake)->
	[lat, lon] = @correct(quake.lat, quake.lon)
	@quakes.add new Quake lat, lon, quake.mag
	@
