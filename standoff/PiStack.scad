/*
 * OpenSCAD library for generating a Raspberry PI Stack consisting of
 * one or more PI's stacked on top of each other
 *
 * Copyright 2016 Peter T Mount
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

include <../Common.scad>
include <StandOff.scad>

basePlate(1);


/*
 * Base plate consists of the base, mounting holes and risers on which to mount the pi
 *
 * model		The PI model, 0=A+, 1=B+, 2B or 3B
 */
module basePlate(model) {
	assign(
		offset=30/2,
		width=30+(model==0?PI_A_WIDTH:PI_B_WIDTH),
		height=30+(model==0?PI_A_HEIGHT:PI_B_HEIGHT)
	) {
		translate([-width/2,-height/2,0]) union() {

			// Base plate
			translate([0,0,-5]) difference() {
				union() {
					cube([width,height,5]);

					// Bolt mounts
					for(c=[0:3])
						translate([width*(c%2),height*(floor(c/2)%2),0])
							cylinder(h=5,r1=8,r2=6);
				}

				// Bolt holes
				for(c=[0:3])
					translate([width*(c%2),height*(floor(c/2)%2),-1])
						cylinder(h=8,r=3.25);

			}

			// Bottom standoffs
			for(c=[0:3])
				translate([offset+(PIHAT_WIDTH*(c%2)),offset+(PIHAT_HEIGHT*(floor(c/2)%2)),0])
					hexStandoff(10, PIHAT_HOLE_PAD_DIAM-1, 2, 6, 2.5, 0, 1, 1);
		}
	}
}
