circleGeo = new THREE.CircleGeometry 25, 64
material = new THREE.MeshBasicMaterial {color: 0xff00ff, opacity: 0.5, lineWidth: 2, wireframe: true}

window.Wave = Wave = (lat, lon)->
    THREE.Object3D.call @, [].slice.call arguments, 2
    @rotation.set lat, lon, 0

    display = new THREE.Mesh circleGeo, material
    display.position.y = 60
    display.rotation.x = Math.PI / 2
    @add display
    @

Wave:: = Object.create THREE.Object3D::