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
include <RaspberryPI.scad>

// Default with Model A+'s
//defaultStack(1,5,4);

// Default with Model 3B's
//defaultStack(3,6,4);

// Default with Zeros
//defaultStack(4,7,4);

// This models one of our stacks, utilises a spare Maplin N60GJ 5 port switch
// so we have room for 4 Model 2B/3B PI's plus the link to the outside world.
switchStack(3,6,4);
module switchStack(model,top,height) {
	translate([10,0,-0]) enclosure(95,120,31);

	translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,-6]) piStandoffs(model,6);
	RaspberryPI(model);
	stackElement(model,top,height);
}

/*
 * Default stack
 *
 * model	The RaspberryPI model to visulize
 * top		The RaspberryPI model to be on top
 * height	The number of PI's between base and top
 */
module defaultStack(model,top,height) {
	translate([0,0,-2]) union() {
		translate([0,0,-6]) basePlate(model);
		RaspberryPI(model);
		stackElement(model,top,height);
	}
}

module enclosure(w,h,d) {
	translate([0,0,-5-d/2])
		difference() {
			cube([w,h,d],center=true);
			cube([w+10,h-8,d-8],center=true);
		}

//	translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,-6]) piStandoffs(model,6);
}

// Stack element, renders a PI and spacers
module stackElement(model,top,height) {
	for(y=[0:(height-2)])
		assign(yo=22*y) {
			translate([0,0,yo+2]) union() {
				translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,0]) piStandoffs(model,20);
				translate([0,0,20]) RaspberryPI(model);
			}
		}

	if(top>0)
		assign(yo=22*(height-1)) {
			translate([0,0,yo+2]) union() {
				translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,0]) piStandoffs(model,20);
				translate([0,0,20]) RaspberryPI(top);
			}
		}
}

/*
 * Base plate consists of the base, mounting holes and risers on which to mount the pi
 *
 */
module basePlate(model) {
	assign(
		offset=30/2,
		width=30+(model==1?PI_A_WIDTH:model==4?PI_Z_WIDTH:PI_B_WIDTH),
		height=30+(model==1?PI_A_HEIGHT:model==4?PI_Z_HEIGHT:PI_B_HEIGHT)
	) {
		translate([-offset-PIHAT_WIDTH/2,-offset-PIHAT_HEIGHT/2,0])
		union() {

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

			translate([offset,offset,0]) piStandoffs(model,6);
		}
	}
}

module piStandoffs(model,ht) {
	assign(w=PIHAT_WIDTH, h=model==4?(PIHAT_HEIGHT/2):PIHAT_HEIGHT) {
		translate([PIHAT_OFFSET_X,PIHAT_OFFSET_Y,0])
			hexStandoff(ht, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

		translate([w-PIHAT_OFFSET_X,PIHAT_OFFSET_Y,0])
			hexStandoff(ht, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

		translate([PIHAT_OFFSET_X,h-PIHAT_OFFSET_Y,0])
			hexStandoff(ht, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

		translate([w-PIHAT_OFFSET_X,h-PIHAT_OFFSET_Y,0])
			hexStandoff(ht, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);
	}
}
