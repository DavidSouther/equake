lerp = (v, a, b, x, y) ->
    if v is a
        x
    else
        (v - a) * (y - x) / (b - a) + x
        

circleGeo = new THREE.CircleGeometry 1, 64
material = new THREE.LineBasicMaterial {color: 0xff00ff, opacity: 0.5, lineWidth: 2}

window.Wave = Wave = (lat, lon)->
    THREE.Object3D.call @, [].slice.call arguments, 2
    @rotation.set lat, lon, 0

    display = new THREE.Line circleGeo, material
    display.position.y = 0
    display.rotation.x = Math.PI / 2
    @add display


    Object.defineProperty @, 'travel', do ->
        _travel = 0
        get: ->
            _travel
        set: (val)->
            # Watcher
            display.position.y = val
            _travel = val

    gui.add @, "travel", -1, 1

    @

Wave:: = Object.create THREE.Object3D::