/*
 * openSCAD for a simple mount for the Raspberry PI Camera Module
 *
 * This file is not for standalone use - it's included in to another
 * openSCAN file for including in to another model.
 *
 * Copyright 2015 Peter T Mount
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

include <PiCameraMount.scad>

// If you want a larger container increase the value here.
// 50 should be viewed as the minimal size for the enclosure.
piCameraStandalone(50);

/*
 * Standalone, generate a model of just the camera module with the specified radius
 */
module piCameraStandalone(radius) {
	translate([6,0,0]) rotate([0,0,180]) piCamera(radius,0);
	translate([-6,-radius*3/2,0]) piCamera(radius,3);
}
