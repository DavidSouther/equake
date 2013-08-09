window.Earth = Earth = ->
	THREE.Object3D.call @, [].slice.call arguments, 0
	
	sphere = new THREE.SphereGeometry 1, 64, 32
	map = THREE.ImageUtils.loadTexture "app/textures/earth_day_4096.jpg"
	# map.anisotropy = stage.renderer.getMaxAnisotropy();
	ground = new THREE.MeshBasicMaterial { map }
	surface = new THREE.Mesh sphere, ground
	surface.rotation.set 0, -Math.PI / 2, 0

	@speed =
		rotation: 0.001

	@add surface
	@

Earth:: = Object.create THREE.Object3D::

Earth::update = (clock)->
	@rotation.y -= @speed.rotation
	c.update? clock for c in @children

toRad = (deg)-> deg * Math.PI / 180
Earth::correct = (lat, lon)-> [toRad(-lat), toRad(lon - 90)]

Earth::quake = (quake)->
	[lat, lon] = @correct(quake.lat, quake.lon)
	@add new QuakeMarker lat, lon, quake.mag
	@add new Wave lat, lon, quake.mag
	@

Earth::wave = (lat, lon)->
	[lat, lon] = @correct lat, lon
	w = new Wave lat, lon
	@add w
	@

Earth::Quake = ->
	@quake (Math.random() * 180 - 90), (Math.random() * 360 - 180), (Math.random() * 10)
	@

Earth::Wave = ->
	@wave 20, 20
	@
