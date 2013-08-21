/*
# `Earth extends Globe`

A `Globe` provides an `Object3D` whos `add` is overridden to place the
child Object3D at some lat/lon on the surface of a conceptual globe.
The child is oriented so the Z axis points out from the globe, the Y axis
points to the north pole, and the X axis is orthagonal, pointing East.
*/


(function() {
  var animationDelay, animationTime, circleGeo, dot, earth, geo, heights, id, markerGeo, next, oneDayMillis, qs, quake, x, y, _i, _len,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.Earth = (function(_super) {
    __extends(Earth, _super);

    /*
    	In the Constructor, we'll add a new sphere with a texture of the Earth.
    	Texture from NASA -
    */


    function Earth() {
      var ground, map, sphere, surface;
      S3age.Extras.Globe.call(this);
      sphere = new THREE.SphereGeometry(this.radius, 64, 32);
      map = THREE.ImageUtils.loadTexture("app/textures/earth_day_4096.jpg");
      ground = new THREE.MeshBasicMaterial({
        map: map
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

  circleGeo.vertices.shift();

  window.Quake = (function(_super) {
    __extends(Quake, _super);

    function Quake(quake) {
      var marker, material, wave,
        _this = this;
      THREE.Object3D.call(this);
      this.id = "quake_" + quake.id;
      this.lat = quake.lat;
      this.lon = quake.lon;
      this.mag = quake.mag;
      this.depth = quake.depth;
      Object.defineProperty(this, 'color', {
        get: function() {
          var color, hue;
          hue = Math.lerp(quake.mag, 0, 9, 0.5, 0);
          color = new THREE.Color();
          color.setHSL(hue, 0.5, 0.5);
          return color;
        }
      });
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

      material = new THREE.LineBasicMaterial({
        color: this.color
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
            if (val > 0.1 * _this.mag) {
              if (wave) {
                _this.remove(wave);
              }
              return;
            }
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


  geo = {
    head: new THREE.CircleGeometry(1, 64),
    line: (function() {
      var g;
      g = new THREE.Geometry();
      g.vertices.push(new THREE.Vector3());
      g.vertices.push(new THREE.Vector3(0, 0, 1));
      return g;
    })()
  };

  window.Pin = (function(_super) {
    __extends(Pin, _super);

    function Pin(quake) {
      var ball, color, height, line, lineMaterial, material, size;
      Quake.apply(this, [].slice.call(arguments, 0));
      /*
      		Color is some value between black and blue. Bluer is stronger quake.
      */

      color = this.color;
      material = new THREE.MeshBasicMaterial({
        color: color,
        side: THREE.DoubleSide
      });
      ball = new THREE.Mesh(geo.head, material);
      height = Math.lerp(this.depth, 0, 100, 0, 0.1);
      ball.position.z = height;
      /*
      		Size of the pin. Values chosen by experimentation.
      */

      size = Math.lerp(this.mag, 0, 10, 0.01, 0.05);
      ball.scale.multiplyScalar(size);
      this.add(ball);
      lineMaterial = new THREE.LineBasicMaterial({
        color: color,
        linewidth: 1
      });
      line = new THREE.Line(geo.line, lineMaterial);
      line.scale.z = height || 0.001;
      this.add(line);
    }

    return Pin;

  })(Quake);

  /*
  Build a new Earth object. Add each of the quakes with each type of marker.
  */


  earth = new Earth();

  for (id in quakes) {
    quake = quakes[id];
    quake.id = id;
  }

  qs = _(quakes).chain().values().sortBy(function(it) {
    return it.time;
  }).value();

  for (_i = 0, _len = qs.length; _i < _len; _i++) {
    quake = qs[_i];
    quake.date = Date.parse(quake.time);
  }

  oneDayMillis = 24 * 60 * 60 * 1000;

  animationTime = 60 * 1000;

  animationDelay = animationTime / oneDayMillis;

  next = function(q) {
    var d1, d2, time;
    if (q === qs.length) {
      return;
    }
    earth.addMarker(new Pin(qs[q]));
    if (q < qs.length - 1) {
      d1 = qs[q + 1].date;
      d2 = qs[q].date;
      time = (d1 - d2) * animationDelay;
    }
    return setTimeout((function() {
      return next(q + 1);
    }), time);
  };

  next(0);

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