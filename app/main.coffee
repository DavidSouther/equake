###
Build a new Earth object. Add each of the quakes with each type of marker.
###
earth = new Earth()

# quakes = _(quakes).map (q, id)->
# 	q.id = id
# 	q

quake.id = id for id, quake of quakes
qs = _(quakes).chain().values().sortBy((it)-> it.time).value()
quake.date = Date.parse quake.time for quake in qs


#one day in milliseconds = 
oneDayMillis = 24 * 60 * 60 * 1000
animationTime = 60 * 1000
animationDelay = animationTime / (oneDayMillis)

next = (q)->
	if q is qs.length then return
	earth.addMarker new Pin qs[q]
	if q < qs.length - 1
		d1 = qs[q + 1].date
		d2 = qs[q].date
		time = (d1 - d2) * animationDelay
	setTimeout (-> next q + 1), time
next 0

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
