window.Earth = Earth = ->
	THREE.Object3D.call @, [].slice.call arguments, 0
	
	sphere = new THREE.SphereGeometry 50, 64, 32
	map = THREE.ImageUtils.loadTexture "app/textures/earth_day_4096.jpg"
	# map.anisotropy = stage.renderer.getMaxAnisotropy();
	ground = new THREE.MeshBasicMaterial { map }
	surface = new THREE.Mesh sphere, ground
	surface.rotation.set 0, -Math.PI / 2, 0

	@speed =
		rotation: 0.001

	@add surface

Earth:: = Object.create THREE.Object3D::

Earth::update = ->
	@rotation.y -= @speed.rotation

toRad = (deg)-> deg * Math.PI / 180

Earth::quake = do ->
	deg = Math.PI / 180
	s1 = 179 * deg
	s2 = 89 * deg
	sphere = new THREE.SphereGeometry 50.001, 4, 4, s1, deg, s2, deg
	dot = new THREE.MeshBasicMaterial { transparent: true, wireframe: true, color: 0xff0000 }
	correct = (lat, lon)-> [toRad(-lat), toRad(lon - 90)]
	(lat, lon)->
		[lat, lon] = correct(lat, lon)
		display = new THREE.Mesh sphere, dot
		display.rotation.set lat, lon, 0
		@add display

Earth::wave = do ->
	circleGeometry = new THREE.CircleGeometry 100, 40
	material = new THREE.LineBasicMaterial { color: 0xff00ff, opacity: 0.5, lineWidth: 2 }
	(lat, lon) ->
		

Earth::Quake = ->
	@quake (Math.random() * 180 - 90), (Math.random() * 360 - 180)