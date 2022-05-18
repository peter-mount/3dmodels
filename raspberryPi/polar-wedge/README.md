# Polar Wedge

This model generates a Polar Wedge capable of holding the Adafruit Mini Pan-Tilt Kit.

For example:
* https://www.adafruit.com/product/1967
* https://shop.pimoroni.com/products/adafruit-mini-pan-tilt-kit-assembled-with-micro-servos

Now that kit is in astronomical terms an Alt-Azimuth mount. It enables the camera (not just the PI) to be rotated 180° horizontally and 150° up and down, based on the local horizon. However if you want to track an object in the sky, say the Moon, then you have to perform additional calculations to convert the moons location to your local site.

What this model does is provide whats known as a Polar Wedge. This is an additional mount which rotates the horizontal azis so that it now rotates not to the local Zenith (straight up) but to the Earth's pole. Now you only need to calculate the position based on equatorial coordinates - negating the need to convert to the observers location.

It also has the additional benefit that the image doesn't rotate as the object traverses the sky.

This model was originally intended for building a Raspberry PI based solar telescope - which I may resume when time allows.

## Usage

This model is self-contained. There's just one configurable parameter, latitude which is your site's latitude (degrees away from the Equator). The default is 51.271749 which is my local latitude.

Now this figure doesn't need to be accurate - mainly as the accuracy of your printer would even things out but this doesn't affect the final result as you are also limited by the accuracy of the servo's and by the attached camera.

When you've configured and printed the model you simply mount the Pan-Tilt kit to the base plate with 4 screws and when positioning it orient it so that the base plate points to the pole. To help there's a small arrow on one end. Point that towards the pole.

## North & South of the Equator

Note: I defined latitude as degrees away from the Equator. This is because with a wedge there's no Noth or South. So if you are at 51.5N or 51.5S then you use 51.5 for latitude.

The reason is that when you use the mount, the camera's zenith (straight up) is pointing to the Earth's pole not up. So if you are in the North then you point that to the North. In the South then it points to the south.

The only other difference is the orientation of the horizontal axis.

If you are in the South then West is in the opposite direction than it is in the North - i.e. it's mirrored. 

Declination (degrees of an object from the equator) is similarly affected.

## Bugs
Currently:
* There's a bug in the math for latitudes 25..35 where the supports don't reach the mount plate requiring manual adjustment.
