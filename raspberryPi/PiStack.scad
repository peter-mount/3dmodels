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

translate([0,0,-2]) union() {
	translate([0,0,-10]) basePlate(1);
	pcb(2);
}

/*
 * A blank plate which matches the dimension of a PI PCB.
 *
 * This can be used to ensure everything mounts together
 *
 * model		0 HAT,
 *				1 PI Model A+
 *				2 PI B+
 *				3 2B or 3B
 *
 */
module pcb(model) {
	assign(w=model<2?PI_A_WIDTH:PI_B_WIDTH,h=PIHAT_HEIGHT,t=2) {
		translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,0]) difference() {

			union() {

				// Base PCB
				translate([PIHAT_EDGE_RADIUS,0,0])
					cube([w-2*PIHAT_EDGE_RADIUS,h,t]);
				translate([0,PIHAT_EDGE_RADIUS,0])
					cube([w,h-2*PIHAT_EDGE_RADIUS,t]);
				translate([PIHAT_EDGE_RADIUS,PIHAT_EDGE_RADIUS,0])
					cylinder(r=PIHAT_EDGE_RADIUS,h=t);
				translate([w-PIHAT_EDGE_RADIUS,PIHAT_EDGE_RADIUS,0])
					cylinder(r=PIHAT_EDGE_RADIUS,h=t);
				translate([PIHAT_EDGE_RADIUS,h-PIHAT_EDGE_RADIUS,0])
					cylinder(r=PIHAT_EDGE_RADIUS,h=t);
				translate([w-PIHAT_EDGE_RADIUS,h-PIHAT_EDGE_RADIUS,0])
					cylinder(r=PIHAT_EDGE_RADIUS,h=t);

				// GPIO, HAT connector below, A/B+ above
				translate([	PIHAT_OFFSET_X+PI_GPIO_OFFSET_X,
								h-PIHAT_OFFSET_Y-PI_GPIO_OFFSET_Y,
								model==0 ? t-(PI_GPIO_DEPTH/2) : (PI_GPIO_DEPTH/2) ])
					cube([PI_GPIO_WIDTH, PI_GPIO_HEIGHT, PI_GPIO_DEPTH],center=true);

				if(model==2) {
					// Ethernet
					translate([w+3-(21/2), 10.25, t+7])
						difference() {
							cube([21,16,14], center=true);
							translate([6,0,0]) cube([10,14,10], center=true);
							translate([6,0,-7]) cube([10,5,5], center=true);
						}

					// USB
					for(o=[29,47])
						translate([w+3-(17/2), o, t+(15.7/2)])
							difference() {
								cube([17,13.5,15.7], center=true);
								for(p=[0:1])
									translate([6,0,-3.5+7*p]) cube([10,10,5], center=true);
							}
				}
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

			// CSI Connector
			translate([PI_CSI_OFFSET_X,PI_CSI_OFFSET_Y,1])
				cube([PI_CSI_HEIGHT+2,PI_CSI_WIDTH+2,t+2],center=true);

			// DSI Connector
			translate([-0.1,PI_DSI_OFFSET_Y-2-PI_CSI_WIDTH/2,-1])
				cube([PI_DSI_OFFSET_X+1,PI_CSI_WIDTH+4,t+2]);
		}
	}
}

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

			// Bottom standoffs
			translate([offset+PIHAT_OFFSET_X,offset+PIHAT_OFFSET_Y,0])
				hexStandoff(10, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

			translate([offset+PIHAT_WIDTH-PIHAT_OFFSET_X,offset+PIHAT_OFFSET_Y,0])
				hexStandoff(10, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

			translate([offset+PIHAT_OFFSET_X,offset+PIHAT_HEIGHT-PIHAT_OFFSET_Y,0])
				hexStandoff(10, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

			translate([offset+PIHAT_WIDTH-PIHAT_OFFSET_X,offset+PIHAT_HEIGHT-PIHAT_OFFSET_Y,0])
				hexStandoff(10, PIHAT_HOLE_PAD_DIAM-1, 1, 6, 2.2, 0, 1, 1);

		}
	}
}
