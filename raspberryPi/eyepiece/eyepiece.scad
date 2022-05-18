/*
 * openSCAD for an adapter for attaching the Raspberry PI Camera Module 
 * to a telescope.
 *
 * This model comes in two parts, the eyepiece mount which attaches directly
 * to the telescope (no eyepiece required) and the back plate.
 *
 * However it's intended that the backplate be incorporated into another model
 * so that the PI itself is mounted with the camera.
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

include <../Common.scad>
include <../cameramount/PiCameraMount.scad>

module eyepiece(diam,mode) {
	// eyediam is the eyepiece diameter, adjusting for extruder diameter
	assign(
		eyediam=(diam*25.4)-3
	) {
		assign(
			eyerad=eyediam/2,
			eyewidth=max(50,eyediam+10)
		) {
			if(mode==0 || mode==2) translate([-6,0,0]) eyepieceFront(eyewidth,eyerad);
			if(mode==1 || mode==2) translate([-6,0,0]) eyepieceBack(eyewidth);
			if(mode==3) {
			  	translate([6,0,0]) rotate([0,0,180]) eyepieceFront(eyewidth,eyerad);
				translate([-6,-eyewidth*3/2,0]) eyepieceBack(eyewidth);
			}
		}
	}
}

module eyepieceFront(eyewidth,eyerad) {
	union() {
		piCamera(eyewidth,0);
		translate([-24,0,piCameraYOffset/4]) rotate([0,90,0]) difference() {
			cylinder( h=24,r=eyerad);
			translate([0,0,-2]) cylinder( h=27,r=eyerad-2);
		}
	}
}

module eyepieceBack(eyewidth) {
	piCamera(eyewidth,3);
}
