# Raspberry PI Camera Enclosure Library for OpenSCAD

This library consists of a single file PiCameraMount.scad which you can include within your own model and it generates an enclosure for the PI Camera Module.

The enclosure consists of two components - the front which exposes the camera lens and the rear which holds everything together. It also provides 4 M4 holes which are used to bolt the two components together.

It's been tested with the original camera module, I've not yet got the new one but as long as the components are in the same place it should work with the new one.

## Usage

To include it within your own model you need to include the library and then call the piCamera() module.

```
include <camera/PiCameraMount.scad>
piCamera( width, mode );
```

Here width is the width of the enclosure in mm. Normally you would use 50 here as that's the smallest minimal size for the enclosure, but sometimes you may want a larger enclosure - see the Telescope Eye Piece models for an example.

Mode is the mode of this call, each one generates a different component:

| mode | component generated |
|:----:| ------------------- |
| 0 | Renders the front where the camera pokes out |
| 1 | The back panel with  the camera cable exiting at the bottom |
| 2 | A plain panel with just the mounting holes |
| 3 | The back panel but with the camera cable exiting from the rear |

In most instances you would use modes 0 and 3.

## Examples

### Basic enclosure

For example, to generate a basic enclosure to just protect the camera you can use the following:

```
include <camera/PiCameraMount.scad>

width=50;

translate([6,0,0]) rotate([0,0,180]) piCamera(width,0);
translate([-6,-width*3/2,0]) piCamera(width,3);
```

Here we generate both the front and rear panels for the enclosure so they are printed together.

You can see this example in the BasicEnclosure.scad file.

