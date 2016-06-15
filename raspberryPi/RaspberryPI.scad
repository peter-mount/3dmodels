/*
 * OpenSCAD library for generating a Raspberry PI.
 *
 * Normally this is used in models to make certain a PI will fit but can be
 * used to generate an actual Model.
 *
 * There's multiple models in this file:
 *
 * Model	Content
 *  0		Raspberry PI Hat
 *  1		Raspberry PI Model A+
 *  2		Raspberry PI Model B+
 *  3		Raspberry PI Model 2B or 3B
 *  4		Raspberry PI Zero
 *  5		Blank top plate for the A+ or Hat
 *  6		Blank top plate for the B+, 2B or 3B
 *  7		Blank top plate for the Zero
 * 	 8		As 5 but with CSI cable slot
 *	 9		As 6 but with CSI cable slot
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
include <Components.scad>

//RaspberryPIFamily(3);
//RaspberryPI(1);
	
/*
 * Utility to generate the entire set of boards as one model.
 *
 * In this instance the HAT model (0) is generated upside down to make printing easier
 * as it has components above the print plane.
 *
 * m	The number of components in a row before starting a new one
 */
module RaspberryPIFamily(m) {
	for(model=[0:9])
		translate([floor(model/m)*90, (model%m)*70, 0]) {
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
 * 				5 Blank top plate for the A+ or Hat
 *				6 Blank top plate for the B+, 2B or 3B
 *				7 Blank top plate for the Zero
 *				8 As 5 but with CSI cable slot
 *				9 As 6 but with CSI cable slot
 */
module RaspberryPI(model) {
	assign(
		w=model<2?PI_A_WIDTH:PI_B_WIDTH,
		h=model==4 || model==6 ? PI_Z_HEIGHT : PIHAT_HEIGHT,
		t=2
	) {
		translate([-PIHAT_WIDTH/2,-PIHAT_HEIGHT/2,0]) difference() {

			union() {

				if(model==0 || model==1 || model==5||model==8)
					RoundedPCB(PI_A_WIDTH, PI_A_HEIGHT, 2, PIHAT_EDGE_RADIUS);
				if(model==2 || model==3||model==6||model==9)
					RoundedPCB(PI_B_WIDTH, PI_B_HEIGHT, 2, PIHAT_EDGE_RADIUS);
				if(model==4 || model==7)
					RoundedPCB(PI_Z_WIDTH, PI_Z_HEIGHT, 2, PIHAT_EDGE_RADIUS);

				// GPIO, HAT connector below, A/B+ above
				if(model==0)
					translate([	PIHAT_OFFSET_X+PI_GPIO_OFFSET_X,
									h-PIHAT_OFFSET_Y-PI_GPIO_OFFSET_Y,
									t-(PI_GPIO_DEPTH/2) ]) GPIO(1);

				if(model>=1 && model<=4)
					translate([	PIHAT_OFFSET_X+PI_GPIO_OFFSET_X,
									h-PIHAT_OFFSET_Y-PI_GPIO_OFFSET_Y,
									PI_GPIO_DEPTH/2 ]) GPIO(0);

				// Ethernet
				if(model==2||model==3)
					translate([w+3-(21/2), 10.25, t+7]) RJ45();

				// USB
				if(model==1)
					translate([w+3-(17/2), 29, t+4]) USB1();
				if(model==2)
					translate([w+3-(17/2), 29, t+(15.7/2)]) USB2();
				if(model==3)
					for(o=[29,47])
						translate([w+3-(17/2), o, t+(15.7/2)]) USB2();

				if(model>=1 && model<=3) {
					// CSI Connector
					translate([PI_CSI_OFFSET_X,PI_CSI_OFFSET_Y,t+1])
						CSI();

					// DSI Connector
					translate([PI_DSI_OFFSET_X,PI_DSI_OFFSET_Y,t+1])
						rotate([0,0,180])
							CSI();
				}

				if(model==1||model==3) {
					translate([53.5,6.2,t+1]) Audio();
					translate([31,6.2,t+1]) HDMI();
					translate([10.6,1.5,t+1]) MicroUSB();
				}

				if(model==4) {
					translate([8,16.9,t+0.5])
						rotate([0,0,90]) MicroSD();
					translate([PI_Z_WIDTH-PIHAT_OFFSET_X,PI_Z_HEIGHT/2,t+0.5])
						rotate([0,0,-90]) ComputeCSI();
					translate([12.4,3,t+1]) MicroHDMI();
					translate([41.4,1.5,t+1]) MicroUSB();
					translate([54,1.5,t+1]) MicroUSB();
				}
			}

			// Mounting holes
			RaspberryPiHoles(model);

			// CSI Connector
			if(model==0||model==8||model==9)
				translate([PI_CSI_OFFSET_X,PI_CSI_OFFSET_Y,1])
					cube([PI_CSI_HEIGHT+2,PI_CSI_WIDTH+2,t+2],center=true);

			// DSI Connector
			if(model==0)
				translate([-0.1,PI_DSI_OFFSET_Y-2-PI_CSI_WIDTH/2,-1])
					cube([PI_DSI_OFFSET_X+1,PI_CSI_WIDTH+4,t+2]);

		}
	}
}

/*
 * Generates the mounting holes for the Raspberry PI.
 * Use this if you want to add them to your own model.
 */
module RaspberryPiHoles(model) {
	if(model==2) {
		// The old Model B had them in different places & they weren't meant
		// for use in mounting stuff so we ignore them
	} else {

		translate([PIHAT_OFFSET_X,PIHAT_OFFSET_Y,-1])
			cylinder(r=PIHAT_HOLE_DIAM/2, h=4);
		translate([PIHAT_OFFSET_X + PIHAT_WIDTH_HOLE,PIHAT_OFFSET_Y,-1])
			cylinder(r=PIHAT_HOLE_DIAM/2, h=4);

		// Zero is half sized
		if(model==4 ||model==7) {
			translate([PIHAT_OFFSET_X,PI_Z_HEIGHT-PIHAT_OFFSET_Y,-1])
				cylinder(r=PIHAT_HOLE_DIAM/2, h=4);
			translate([PIHAT_OFFSET_X + PIHAT_WIDTH_HOLE,PI_Z_HEIGHT-PIHAT_OFFSET_Y,-1])
				cylinder(r=PIHAT_HOLE_DIAM/2, h=4);
		}else{
			translate([PIHAT_OFFSET_X,PIHAT_HEIGHT-PIHAT_OFFSET_Y,-1])
				cylinder(r=PIHAT_HOLE_DIAM/2, h=4);
			translate([PIHAT_OFFSET_X + PIHAT_WIDTH_HOLE,PIHAT_HEIGHT-PIHAT_OFFSET_Y,-1])
				cylinder(r=PIHAT_HOLE_DIAM/2, h=4);
		}
	}
}

