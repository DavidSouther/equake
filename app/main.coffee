window.stage = stage = new S3age "#container",
	expose: true
	debug:
		showstats: true
	camera:
		near: 0.01
		position: [0, 0, 4]
	scene:
		lights: [ new THREE.AmbientLight 0xdddddd ]
		fog: new THREE.Fog 0x333333, 0.1
window.earth = earth = new Earth()
stage.scene.add earth

stage.controls = do ->
	ZERO = new THREE.Vector3 0, 0, 0
	DAMPING = 
		ZOOM:
			FOV: 250
			TRUCK: 7500
		SPIN:
			UP: 2500
			LEFT: 15000

	zoom = new BoundDamper 35, 70
	r = new BoundDamper 2, 7.5
	r.position = 3
	spin =
		up: new SigmoidDamper()
		left: new Damper()

	stage.renderer.domElement.addEventListener "mousewheel", (e)->
		if e.altKey is true
			zoom.push e.wheelDeltaX / DAMPING.ZOOM.FOV
			r.push -e.wheelDeltaY / DAMPING.ZOOM.TRUCK
		else
			spin.up.push -e.wheelDeltaY / DAMPING.SPIN.UP
			spin.left.push e.wheelDeltaX / DAMPING.SPIN.LEFT

	target: ZERO
	update: ->
		d.step() for d in [spin.left, spin.up, r, zoom]
		stage.camera.fov = zoom.position
		phi = spin.up.position * Math.PI
		theta = spin.left.position * Math.PI
		camera.position.fromSpherical theta, phi, r.position
		camera.position.add stage.controls.target
		camera.lookAt stage.controls.target

for id, quake of quakes
	earth.quake quake
