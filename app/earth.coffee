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
