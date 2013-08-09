lerp (v, a, b, x, y) ->
    (v === a) ? x : (v - a) * (y - x) / (b - a) + x

circleGeo = new THREE.CircleGeometry 50.1, 64
material = new THREE.MeshBasicMaterial {color: 0xff00ff, opacity: 0.5, lineWidth: 2, wireframe: true}

window.Wave = Wave = (lat, lon)->
    THREE.Object3D.call @, [].slice.call arguments, 2
    @rotation.set lat, lon, 0

    display = new THREE.Mesh circleGeo, material
    display.position.y = 0
    display.rotation.x = Math.PI / 2
    @add display


    Object.defineProperty @, 'travel', do ->
        _travel = 0
        get: ->
            console.log "getting wave travel"
            _travel
        set: (val)->
            console.log "setting wave travel"
            # Watcher
            display.position.y = val
            _travel = val

    log = =>
        console.log @

    setTimeout log, 100

    gui.add @, "travel", -50, 50

    

    @

Wave:: = Object.create THREE.Object3D::