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
