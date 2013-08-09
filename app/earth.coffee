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
	map = THREE.ImageUtils.loadTexture "app/textures/quake-dot.png"
	sphere = new THREE.SphereGeometry 50.1, 64, 32
	(lat, lon)->
		lon -= 90
		dot = new THREE.MeshBasicMaterial { map, transparent: true }
		display = new THREE.Mesh sphere, dot
		display.rotation.set toRad(lat), toRad(lon), 0
		@add display

Earth::Quake = ->
	@quake 20, 20