# Raspberry PI Eyepiece Enclosure

This model generates a eyepiece enclosure for the Raspberry PI Camera so that the camera can be mounted to an Astronomical Telescope.

## Requirements

It requires our Common.scad and PiCameraMount.scad libraries

## Usage

To include it within your own model simply include the library and then call the eyepiece() module.

```
include <eyepiece/eyepiece.scad>

eyepiece( diameter, mode );
```

Here diameter is the diameter of the telescope eyepiece holder in inches (as thats the usual unit used for eyepieces). The following table lists the common sizes

| diameter | Telescope type |
|:--------:| -------------- |
| 1.25 | This is the most common size for the majority of modern telescopes |
| 2 | Larger telescopes can accept 2" eyepieces, usualy for Prime focus work |
| 0.925 | Older & some cheaper telescopes use the smaller diameter |

mode determines which component is generated:

| mode | component generated |
|:----:| ------------------- |
| 0 | Generates the front with the eyepiece tube |
| 1 | Generates the back component |
| 2 | Generates both as one model as they would appear when assembled |
| 3 | Generates both as one model separated suitable for printing |

* When embeding, you would normally embed just the back (mode 1) in your model, and print the front separately & bolt the components together during assembly.
* Using mode 2 is useful if visualising how the final model fits together.

## Example

Here we will generate a basic camera mount for telescopes using the standard 1.25" eyepieces.

```
include <eyepeice/eyepiece.scad>

eyepiece(1.25,1);
```

## STL Files

This directory contains the following STL files which consist of the standard eyepiece sizes:

| file | diameter | component |
| ---- |:--------:| --------- |
| eyepiece-0925.stl | 0.925 | 0.925" Telescope mount |
| eyepiece-0925-combi.stl | 0.925 | 0.925" Front & Back components |
| eyepiece-125.stl | 1.25 | 1.25" Telescope mount |
| eyepiece-125-combi.stl | 1.25 | 1.25" Front & Back components |
| eyepiece-2.stl | 2 | 2" Telescope mount |
| eyepiece-2-combi.stl | 2 | 2" Front & Back components |

* The eyepiece-##.stl files are so you don't have to generate them yourself and are including the backs in your own projects.
* The combi files include both front and back plates if you want just the basic holder in one print

## Additional SCAD files

The additional scad files are those used to generate the above STL's.
