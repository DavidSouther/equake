gui = new dat.GUI()
window.stage = stage = new S3age "#container",
	expose: true
	debug:
		showstats: true
	camera: position: [0, 0, 200]
	scene: 
		lights: [ new THREE.AmbientLight 0xdddddd ]
		children: [  ]
window.earth = earth = new Earth()
stage.scene.add earth

gui.add earth.speed, "rotation", 0, 0.005
gui.add earth, "Quake"
gui.add earth, "Wave"
