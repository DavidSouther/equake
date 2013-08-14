window.Earth = Earth = ->
	THREE.Object3D.call @, [].slice.call arguments, 0
	@add @tilted = new THREE.Object3D()
	@rotation.z = Math.toRad 23.4

	@speed = rotation: 0.001

	sphere = new THREE.SphereGeometry 1, 64, 32
	map = THREE.ImageUtils.loadTexture "app/textures/earth_day_4096.jpg"
	ground = new THREE.MeshBasicMaterial { map }
	surface = new THREE.Mesh sphere, ground
	@tilted.add surface

	@tilted.add @quakes = new THREE.Object3D()
	@quakes.id = "earth_quakes"
	@

Earth:: = Object.create THREE.Object3D::

Earth::update = (clock)->
	# @tilted.rotation.y += @speed.rotation
	q.update? clock for q in @quakes.children

Earth::correct = (lat, lon)->
	[
		Math.toRad parseFloat lat
		Math.toRad parseFloat lon
	]

Earth::quake = (quake)->
	[lat, lon] = @correct(quake.lat, quake.lon)
	@quakes.add new Quake lat, lon, quake.mag
	@
