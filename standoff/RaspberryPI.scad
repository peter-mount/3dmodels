/*
 * OpenSCAD library for generating a Raspberry PI.
 *
 * Normally this is used in models to make certain a PI will fit but can be
 * used to generate an actual Model.
 *
 * There's 4 models within this file:
 *
 * 0	Raspberry PI Hat PCB
 * 1	Raspberry PI Model A+
 * 2	Raspberry PI Model B+
 * 3	Raspberry PI Model 2B or 3B
 * 4	Raspberry PI Zero
 *
 * All of the models have the major components present, GPIO, mounting holes,
 * USB, camera & display ports, where appropriate.
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

RaspberryPIFamily();

/*
 * Utility to generate the entire set of boards as one model.
 *
 * In this instance the HAT is generated upside down to make printing easier
 * as it has components above the print plane.
 */
module RaspberryPIFamily() {
	for(model=[0:3])
		translate([floor(model/2)*80, (model%2)*70, 0]) {
			if(model==0) {
				// Rotate HAT so everything is above the print plane
				rotate([180,0,0]) RaspberryPI(model);
			} else {
				RaspberryPI(model);
			}
		}
}

/*
 * Generates the appropriate Raspberry PI board
 *
 * model		0 HAT,
 *				1 PI Model A+
 *				2 PI B+
 *				3 2B or 3B
 *				4 Zero
 */
module RaspberryPI(model) {
	assign(w=model<2?PI_A_WIDTH:PI_B_WIDTH,h=PIHAT_HEIGHT,t=2) {
		translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,0]) difference() {

			union() {

				if(model==0 || model==1)
					RoundedPCB(PI_A_WIDTH, PI_A_HEIGHT, 2, PIHAT_EDGE_RADIUS);
				if(model==2 || model==3)
					RoundedPCB(PI_A_WIDTH, PI_A_HEIGHT, 2, PIHAT_EDGE_RADIUS);
				if(model==4)
					RoundedPCB(PI_Z_WIDTH, PI_Z_HEIGHT, 2, PIHAT_EDGE_RADIUS);

				// GPIO, HAT connector below, A/B+ above
				if(model==0) {
					translate([	PIHAT_OFFSET_X+PI_GPIO_OFFSET_X,
									h-PIHAT_OFFSET_Y-PI_GPIO_OFFSET_Y,
									t-(PI_GPIO_DEPTH/2) ])
						GPIO(1);
				} else {
					translate([	PIHAT_OFFSET_X+PI_GPIO_OFFSET_X,
									h-PIHAT_OFFSET_Y-PI_GPIO_OFFSET_Y,
									PI_GPIO_DEPTH/2 ])
						GPIO(0);
				}

				// Ethernet
				if(model==2||model==3)
					translate([w+3-(21/2), 10.25, t+7]) RJ45();

				// USB
				if(model==2)
					translate([w+3-(17/2), 29, t+(15.7/2)]) USB2();
				if(model==3)
					for(o=[29,47])
						translate([w+3-(17/2), o, t+(15.7/2)]) USB2();
			}

			// Mounting holes
			translate([0,0,-1]) {
				translate([PIHAT_OFFSET_X,PIHAT_OFFSET_Y,0])
					cylinder(r=PIHAT_HOLE_DIAM/2, h=4);

				translate([PIHAT_WIDTH-PIHAT_OFFSET_X,PIHAT_OFFSET_Y,0])
					cylinder(r=PIHAT_HOLE_DIAM/2, h=4);

				translate([PIHAT_OFFSET_X,PIHAT_HEIGHT-PIHAT_OFFSET_Y,0])
					cylinder(r=PIHAT_HOLE_DIAM/2, h=4);

				translate([PIHAT_WIDTH-PIHAT_OFFSET_X,PIHAT_HEIGHT-PIHAT_OFFSET_Y,0])
					cylinder(r=PIHAT_HOLE_DIAM/2, h=4);
			}

			// CSI/DSI cutouts
			if(model==0) {
				// CSI Connector
				translate([PI_CSI_OFFSET_X,PI_CSI_OFFSET_Y,1])
					cube([PI_CSI_HEIGHT+2,PI_CSI_WIDTH+2,t+2],center=true);

				// DSI Connector
				translate([-0.1,PI_DSI_OFFSET_Y-2-PI_CSI_WIDTH/2,-1])
					cube([PI_DSI_OFFSET_X+1,PI_CSI_WIDTH+4,t+2]);
			}
		}
	}
}

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
model RoundedPCB(w,h,t,r) {
	translate([r,0,0])
		cube([w-2*r,h,t]);
	translate([0,r,0])
		cube([w,h-2*r,t]);
	translate([r,r,0])
		cylinder(r=r,h=t);
	translate([w-r,r,0])
		cylinder(r=r,h=t);
	translate([r,h-r,0])
		cylinder(r=Pr,h=t);
	translate([w-r,h-r,0])
		cylinder(r=r,h=t);
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
