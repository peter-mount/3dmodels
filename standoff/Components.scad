/*
 * OpenSCAD library for generating miscelaneous connectors in a model.
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

/*
 * GPIO Connector
 *
 * mode	0=male, 1=female
 */
module GPIO(mode) {
	if(mode==0) {
		translate([0,0,-PI_GPIO_DEPTH/2+2])
			cube([PI_GPIO_WIDTH, PI_GPIO_HEIGHT, 2],center=true);
		cube([PI_GPIO_WIDTH-3, PI_GPIO_HEIGHT-3, PI_GPIO_DEPTH-4],center=true);
	} else {
		difference() {
			cube([PI_GPIO_WIDTH, PI_GPIO_HEIGHT, PI_GPIO_DEPTH-4],center=true);
			translate([0,0,-1])
				cube([PI_GPIO_WIDTH-2, PI_GPIO_HEIGHT-2, PI_GPIO_DEPTH-4],center=true);
		}
	}
}

/*
 * A Rounded PCB
 *
 * w width
 * h height
 * t thickness
 * r corner radius
 */
module RoundedPCB(w,h,t,r) {
	union() {
		translate([r,0,0])			cube([w-2*r,h,t]);
		translate([0,r,0])			cube([w,h-2*r,t]);
		translate([r,r,0])			cylinder(r=r,h=t);
		translate([w-r,r,0])		cylinder(r=r,h=t);
		translate([r,h-r,0])		cylinder(r=r,h=t);
		translate([w-r,h-r,0])	cylinder(r=r,h=t);
	}
}

/*
 * RJ45 Connector.
 *
 * Translate to the middle of the component before calling.
 *
 * Dimensions [21,16,14]
 */
module RJ45() {
	difference() {
		cube([21,16,14], center=true);
		translate([6,0,0]) cube([10,14,10], center=true);
		translate([6,0,-7]) cube([10,5,5], center=true);
	}
}

/*
 * MicroUSB socket as on the PI2
 */
module MicroUSB() {
       cube([6.8,5.5,3],center=true);
}

/*
 * A 2 port USB connectior as present on the Raspberry PI Models B/B+/2B & 3B
 *
 * Translate to the middle of the component before calling.
 *
 * Dimensions [17,13.5,15.7]
 */
module USB2() {
	difference() {
		cube([17,13.5,15.7], center=true);
		for(p=[0:1])
			translate([6,0,-3.5+7*p]) cube([10,10,5], center=true);
	}
}

/*
 * CSI Camera interface (Also for DSI)
 */
module CSI() {
	union() {
		cube([3,20,6],center=true);
		translate([2,0,0]) cube([3,10,6],center=true);
		translate([1.5,5,0]) rotate([0,0,45]) cube([3,3,6],center=true);
		translate([1.5,-5,0]) rotate([0,0,-45]) cube([3,3,6],center=true);
	}
}

/*
 * Audio Jack Socker as on the PI2
 */
module Audio() {
	union() {
		cube([6.8,12.4,4.5],center=true);
		translate([0,-6.2,0]) rotate([90,0,0]) cylinder(r=2,h=2);
	}
}

module HDMI() {
	cube([15,11.5,5.6],center=true);
}
