# [equake](http://equake.souther.co)


**Riley Davis**

The idea behind this project was the xkcd comic http://xkcd.com/723/.

I really like to make complex or large-scale scientific knowledge 
more accessbile by tying it to scales that people already understand.

We thought it would be interesting to plot waves from real earthquakes onto a globe 
and see how fast the waves actually travel through the crust. This tool could easily
be used to map out tweets (or any other geographic data) if there was another 
earthquake in the US, or anywhere in the world.


**David Souther**

We really wanted to have the physicallity of the spinning globe that I remember fondly from childhood, while adding
the dynamicism of a quick scripts. To implement this, we were able to use and build a few tools.

The data is a day's worth of earthquake incidents from the USGS database.

Each piece of data has a (lat, lon) and a magnitude.

We place 3-d markers on the surface of a globe, changing their size and color bsae on the magnitude.

The Earth extends a globe class, provided by S3age. It adds a sphere surface textured with a NASA Earth texture. The Globe base class provides a method, `addMarker(Marker<THREE.Object3D>[, lat, lon])` which places a marker at the correct location on the globe's surface. The marker's local 3d space is oriented with the Z-axis pointing out along the radius, the Y axis pointing to the North Pole, and the X axis perpindicular to the two, pointing east.

The rendering is handled by S3age - the equake app only handles creating the 3d geometry and materials of the markers. S3age also provides the controls for the scene.

We built the S3age globe class at the same time. Having a library that can easily and quickly orient along the sufave of the globe will be  a boon in future visualizations we make.

## Code

**[index](index.html)**

Loads libraries, scripts. Provides instruction and hook for S3age.

**[app/main](app/main.coffee)**

Creates Earth, adds quake markers, instantiates s3age.

**[app/earth](app/earth.coffee)**

Extends Globe, adds texture.

**[app/quake](app/quake.coffee), [app/pin](app/pin.coffee)**

Two different quake marker styles.
