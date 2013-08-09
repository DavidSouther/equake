window.Earth = Earth = ->
	THREE.Object3D.call @, [].slice.call arguments, 0
	
	sphere = new THREE.SphereGeometry 50, 32, 16
	map = THREE.ImageUtils.loadTexture "app/textures/earth_day_medium.jpg"
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

Earth::quake = (lat, lon)->
