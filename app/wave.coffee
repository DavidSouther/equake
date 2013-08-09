lerp = (v, a, b, x, y) ->
    if v is a
        x
    else
        (v - a) * (y - x) / (b - a) + x
        
circleGeo = new THREE.CircleGeometry 1, 64

window.Wave = Wave = (lat, lon, mag)->
    THREE.Object3D.call @, [].slice.call arguments, 2
    @rotation.set lat, lon, 0

    display = new THREE.Line circleGeo, material
    display.position.x = 0
    display.rotation.y = Math.PI / 2
    material = new THREE.LineBasicMaterial {color: 0xff00ff, opacity: 0.5}
    @add display

    Object.defineProperty @, 'travel', do ->
        _travel = 0
        get: ->
            _travel
        set: (val)->
            val = val % (0.1 * mag)
            val = (val is 0 ) && 0.001 || val
            display.scale.y = display.scale.x = Math.sin val
            display.position.x = Math.cos val
            material.opacity = 1 - (val * Math.PI)

            _travel = val
    @travel = 0
    @

Wave:: = Object.create THREE.Object3D::
Wave::update = (clock)->
    @travel = (@travel + 0.001) % Math.PI
