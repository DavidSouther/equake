window.gui = new dat.GUI()
window.stage = stage = new S3age "#container",
	expose: true
	debug:
		showstats: true
	camera:
        near: 0.01
		position: [0, 0, 2]
	scene:
		lights: [ new THREE.AmbientLight 0xdddddd ]
		children: [  ]
		fog: new THREE.Fog 0x333333, 1
camera.position.z = 2
window.earth = earth = new Earth()
stage.scene.add earth

Number::clamp = Number::clamp || (a, b)-> Math.min(b, Math.max(@, a))
stage.controls = do ->
	zoom = 0
	DAMPING = 250
	stage.renderer.domElement.addEventListener "mousewheel", (e)->
		zoom -= (e.wheelDeltaY / DAMPING)
		zoom = zoom.clamp -6, 6
	update: ->
		# Sigmoid
		f = 1 / (1 + Math.exp(-zoom))
		# f = (zoom + 6) / 12
		f = (f * 35) + 35
		stage.camera.fov = f

gui.add earth.speed, "rotation", 0, 0.005
gui.add camera.position, "z", 0, 5

for id, quake of quakes
	earth.quake quake
