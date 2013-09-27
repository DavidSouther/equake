/*
# `Earth extends Globe`

A `Globe` provides an `Object3D` whos `add` is overridden to place the
child Object3D at some lat/lon on the surface of a conceptual globe.
The child is oriented so the Z axis points out from the globe, the Y axis
points to the north pole, and the X axis is orthagonal, pointing East.
*/


(function() {
  var circleGeo, dot, earth, geom, heights, id, markerGeo, quake, x, y,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Earth = (function(_super) {
    __extends(Earth, _super);

    /*
    	In the Constructor, we'll add a new sphere with a texture of the Earth.
    	Texture from NASA -
    */


    function Earth() {
      var color, ground, map, sphere, surface;
      S3age.Extras.Globe.call(this);
      sphere = new THREE.SphereGeometry(this.radius, 64, 32);
      map = THREE.ImageUtils.loadTexture("app/textures/earth_day_4096.jpg");
      color = 0xFFFFFF;
      ground = new THREE.MeshBasicMaterial({
        map: map,
        color: color
      });
      surface = new THREE.Mesh(sphere, ground);
      this.add(surface);
    }

    return Earth;

  })(S3age.Extras.Globe);

  /*
  # Quake Marker
  
  Marker to show the magnitude and speed of the quake.
  The heights array is a list of numbers for the "canonical"
  seismograph icon. It will be scaled to correspond to magnitude.
  */


  heights = [0, 1, -0.75, 5, -1, 1.5, -0.75, 0.3, 0];

  /*
  To improve memory performance, we only create on instance
  of the geometry and color.
  */


  markerGeo = new THREE.Geometry();

  markerGeo.vertices = (function() {
    var _i, _len, _results;
    _results = [];
    for (x = _i = 0, _len = heights.length; _i < _len; x = ++_i) {
      y = heights[x];
      _results.push(new THREE.Vector3(x, y, 0));
    }
    return _results;
  })();

  dot = new THREE.LineBasicMaterial({
    color: 0xff0000,
    lineWidth: 2
  });

  circleGeo = new THREE.CircleGeometry(1, 128);

  window.Quake = (function(_super) {
    __extends(Quake, _super);

    function Quake(id, quake) {
      var color, marker, material, wave,
        _this = this;
      THREE.Object3D.call(this);
      this.id = "quake_" + id;
      this.lat = quake.lat;
      this.lon = quake.lon;
      this.mag = quake.mag;
      /*
      		Each class gets its own marker, an instance of `THREE.Line`.
      		All the lines share the geometry and
      */

      marker = new THREE.Line(markerGeo, dot);
      marker.scale.x = 0.005;
      marker.scale.y = 0.001 * this.mag;
      this.add(marker);
      /*
      		The wave is simply a circle.
      		The color for the wave on the surface of the earth is tied
      		to the magnitude of the earthquake - darker purple is weaker quake.
      */

      color = new THREE.Color(0x000000);
      color.setHSL(0.8, 1, Math.lerp(this.mag, 0, 10, 0, 1));
      material = new THREE.LineBasicMaterial({
        color: color
      });
      wave = new THREE.Line(circleGeo, material);
      this.add(wave);
      /*
      		Changing the `travel` property on the marker has side effects.
      		The anonymous function binds to the ctor instance, and wraps a
      		private local variable.
      */

      Object.defineProperty(this, 'travel', (function() {
        var _travel;
        _travel = 0;
        return {
          get: function() {
            return _travel;
          },
          set: function(val) {
            val = val % (0.1 * _this.mag);
            val = val === 0 ? 0.0001 : val;
            wave.scale.y = wave.scale.x = Math.sin(val);
            wave.position.z = Math.cos(val) - 1;
            return _travel = val;
          }
        };
      })());
      this.travel = 0;
      this;
    }

    Quake.prototype.update = function(clock) {
      return this.travel += 0.001;
    };

    return Quake;

  })(THREE.Object3D);

  /*
  # Pin marker
  
  One of two marker types we build for this. This is a ball at the end
  of a tube, to create the quarkboard Pin concept.
  */


  geom = new THREE.SphereGeometry(1, 20, 20);

  window.Pin = (function(_super) {
    __extends(Pin, _super);

    function Pin(lat, lon, mag) {
      var ball, color, material, size;
      this.lat = lat;
      this.lon = lon;
      this.mag = mag;
      Pin.__super__.constructor.call(this);
      /*
      		Color is some value between black and blue. Bluer is stronger quake.
      */

      color = Math.lerp(this.mag, 0, 10, 0x000000, 0x0000ff);
      material = new THREE.MeshBasicMaterial({
        color: color
      });
      ball = new THREE.Mesh(geom, material);
      /*
      		Size of the pin. Values chosen by experimentation.
      */

      size = Math.lerp(this.mag, 0, 10, 0.01, 0.05);
      ball.position.z = size / 2;
      ball.scale.multiplyScalar(size);
      this.add(ball);
    }

    return Pin;

  })(THREE.Object3D);

  /*
  Build a new Earth object. Add each of the quakes with each type of marker.
  */


  earth = new Earth();

  for (id in quakes) {
    quake = quakes[id];
    earth.addMarker(new Quake(id, quake));
    earth.addMarker(new Pin(quake.lat, quake.lon, quake.mag));
  }

  /*
  A S3age manages a variety of details of the 3D scene. In this case,
  some ambient light, the Earth with Quakes, and a Sphere control.
  */


  new S3age("#container", {
    camera: {
      position: [-3, 3, 4],
      lookAt: [0, 0, 0]
    },
    scene: {
      lights: [new THREE.AmbientLight(0xdddddd)],
      children: [earth]
    },
    controls: THREE.OrbitControls,
    testing: true,
    expose: true
  });

}).call(this);

/*
//@ sourceMappingURL=full.js.map
*/