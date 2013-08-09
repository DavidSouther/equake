gui = new dat.GUI()
window.stage = stage = new S3age "#container",
	camera: position: [0, 0, 100]
	scene: 
		lights: [ new THREE.AmbientLight 0xdddddd ]
		children: [  ]
window.earth = earth = new Earth()
stage.scene.add earth

gui.add earth.speed, "rotation", 0, 0.005
gui.add earth, "Quake"
gui.add earth, "wave"
