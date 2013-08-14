window.gui = new dat.GUI()
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
		up: new BoundDamper -6, 6
		left: new Damper()

	stage.renderer.domElement.addEventListener "mousewheel", (e)->
		if e.altKey is true
			spin.up.push -e.wheelDeltaY / DAMPING.SPIN.UP
			zoom.push e.wheelDeltaX / DAMPING.ZOOM.FOV
		else
			r.push -e.wheelDeltaY / DAMPING.ZOOM.TRUCK
			spin.left.push -e.wheelDeltaX / DAMPING.SPIN.LEFT

	update: ->
		d.step() for d in [spin.left, spin.up, r, zoom]
		stage.camera.fov = zoom.position
		phi = Math.sigmoid(spin.up.position) * Math.PI
		theta = spin.left.position * Math.PI
		camera.position.fromSpherical theta, phi, r.position
		camera.lookAt ZERO

# stage.controls.update = ->


gui.add earth.speed, "rotation", 0, 0.005

for id, quake of quakes
	earth.quake quake
