# equake

An earthquake visualization.

The data is a day's worth of earthquake incidents from the USGS database.

Each piece of data has a (lat, lon) and a magnitude.

We place 3-d markers on the surface of a globe, changing their size and color bsae on the magnitude.

The Earth extends a globe class, provided by S3age. It adds a sphere surface textured with a NASA Earth texture. The Globe base class provides a method, `addMarker(Marker<THREE.Object3D>[, lat, lon])` which places a marker at the correct location on the globe's surface. The marker's local 3d space is oriented with the Z-axis pointing out along the radius, the Y axis pointing to the North Pole, and the X axis perpindicular to the two, pointing east.

The rendering is handled by S3age - the equake app only handles creating the 3d geometry and materials of the markers. S3age also provides the controls for the scene.

## Code

### `[index.html](index.html)`

Loads libraries, scripts. Provides instruction and hook for S3age.

### `[app/main.coffee](app/main.coffee)`

Creates Earth, adds quake markers, instantiates s3age.

### `[app/earth.coffee](app/earth.coffee)`

Extends Globe, adds texture.

### `[app/quake.coffee](app/quake.coffee)`, `[app/pin.coffee](app/pin.coffee)`

Two different quake marker styles.
