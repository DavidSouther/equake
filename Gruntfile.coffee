module.exports = (grunt)->
	grunt.initConfig
		coffee:
			bundle:
				files: "bundle/full.js": [
					"app/earth.coffee"
					"app/quake.coffee"
					"app/pin.coffee"
					"app/main.coffee"
				]
				options:
					join: yes
					sourceMap: yes

		uglify:
			vendor:
				files: "bundle/vendor.js": [
					"bower_components/s3age/lib/s3age.js"
					# "bower_components/s3age/lib/s3age.controls.js"
					"bower_components/s3age/lib/s3age.extras.js"
					"app/vendor/orbitcontrols.js"
				]
		watch:
			app:
				files: [ 'app/*.coffee' ]
				tasks: [ 'default']

	grunt.loadNpmTasks "grunt-contrib-coffee"
	grunt.loadNpmTasks "grunt-contrib-uglify"
	grunt.loadNpmTasks "grunt-contrib-watch"

	grunt.registerTask "default", ["coffee:bundle", "uglify:vendor"]
