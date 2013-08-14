earth = new Earth()
earth.addMarker new Quake id, quake for id, quake of quakes

window.stage = new S3age "#container",
	expose: true
	debug:
		showstats: true
	camera:
		near: 0.01
		position: [0, 0, 4]
	scene:
		lights: [ new THREE.AmbientLight 0xdddddd ]
		fog: new THREE.Fog 0x333333, 0.1
		children: [ earth ]
	controls: S3age.Controls.Sphere
