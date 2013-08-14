window.Earth = Earth = ->
	S3age.Extras.Globe.apply @, [].slice.call arguments, 0
	@
Earth:: = Object.create S3age.Extras.Globe::
