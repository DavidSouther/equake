THREE.Vector3::fromSpherical = (theta, phi, r)->
	st = Math.sin theta
	ct = Math.cos theta
	sp = Math.sin phi
	cp = Math.cos phi

	@x = r * sp * ct
	@z = r * sp * st
	@y = r * cp

	@

window.Damper = (@friction = 0.1)->
	@position = 0
	@velocity = 0
	@
Damper::step = ->
	@position += @velocity
	@velocity *= 1 - @friction
	@

Damper::push = (acceleration)->
	@velocity += acceleration
	@

window.BoundDamper = (@min = -1, @max = 1, @friction = 0.1)->
	Damper.call @
	@delta = (@max - @min) * 2
	@
BoundDamper:: = Object.create Damper::
BoundDamper::step = ->
	Damper::step.call @
	@position = @position.clamp @min, @max
	@
BoundDamper::push = (acceleration)->
	Damper::push.call @, acceleration
	@velocity = @velocity.clamp -@friction * @delta, @friction * @delta
	@

Number::clamp = Number::clamp || (a, b)-> Math.min(b, Math.max(@, a))
Math.sigmoid = Math.sigmoid || (x)-> 1 / (1 + Math.exp(-x))