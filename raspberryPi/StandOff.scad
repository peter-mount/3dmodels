/*
 * OpenSCAD library for generating PCB Standoff components
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

/* Uncomment to view all possible combinations
for(ts=[0,1,2]) {
	for(bs=[0,1,2]) {
		translate([20*ts,20*bs,0])
			roundStandoff( 20, 6, ts, 5, 2.5, bs, 5, 2.5 );
		translate([70+20*ts,20*bs,0])
			squareStandoff( 20, 6, ts, 5, 2.5, bs, 5, 2.5 );
		translate([20*ts,70+20*bs,0])
			hexStandoff( 20, 6, ts, 5, 2.5, bs, 5, 2.5 );
	}
}
*/

/*
 * A Round standoff
 *
 * height			Height mm
 * diam			Diameter mm
 * topStyle		0=Flat, 1=Male, 2=Female
 * topHeight		Height/Depth mm
 * topDiam		Diameter mm
 * bottomStyle	0=Flat, 1=Male, 2=Female
 * bottomHeight	Height/Depth mm
 * bottomDiam	Diameter mm
 */
module roundStandoff(height,diam,topStyle,topHeight,topDiam,bottomStyle,bottomHeight, bottomDiam) {
	assign( ) {
		difference() {
			union(){
				translate([0, 0, height/2])
					cylinder(height, r = diam/2, center = true, $fn = 12);
				maleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam);
			}
			femaleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam);
		}
	}
}

/*
 * A Square standoff
 *
 * height			Height mm
 * diam			Diameter mm
 * topStyle		0=Flat, 1=Male, 2=Female
 * topHeight		Height/Depth mm
 * topDiam		Diameter mm
 * bottomStyle	0=Flat, 1=Male, 2=Female
 * bottomHeight	Height/Depth mm
 * bottomDiam	Diameter mm
 */
module squareStandoff(height,diam,topStyle,topHeight,topDiam,bottomStyle,bottomHeight, bottomDiam) {
	assign( ) {
		difference() {
			union(){
				translate([0, 0, height/2])
					cube([diam, diam, height], center = true);
				maleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam);
			}
			femaleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam);
		}
	}
}

/*
 * A Hex standoff
 *
 * height			Height mm
 * diam			Diameter mm
 * topStyle		0=Flat, 1=Male, 2=Female
 * topHeight		Height/Depth mm
 * topDiam		Diameter mm
 * bottomStyle	0=Flat, 1=Male, 2=Female
 * bottomHeight	Height/Depth mm
 * bottomDiam	Diameter mm
 */
module hexStandoff(height,diam,topStyle,topHeight,topDiam,bottomStyle,bottomHeight, bottomDiam) {
	assign( ) {
		difference() {
			union(){
				translate([0, 0, height/2])
					cylinder(height, r = diam/2, center = true, $fn = 6);
				maleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam);
			}
			femaleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam);
		}
	}
}

module maleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam) {
	if(topStyle==1)
		translate([0,0, height + topHeight/2 - 0.1])
			cylinder(topHeight + 0.1, r = topDiam/2 -0.1, $fn = 12, center = true);
	if(bottomStyle==1)
		translate([0,0, -bottomHeight/2 - 0.1])
			cylinder( bottomHeight+0.1, r = bottomDiam/2 -0.1, $fn = 12, center = true);
}

module femaleStandoff(height,topStyle,topHeight,topDiam,bottomStyle,bottomHeight,bottomDiam) {
	if(topStyle==2)
		translate([0,0, height + topHeight/2 - 0.1])
			cylinder(height + 0.1, r = topDiam/2 +0.1, $fn = 12, center = true);
	if(bottomStyle==2)
		translate([0,0, bottomHeight/2 ])
			cylinder( bottomHeight+0.1, r = bottomDiam/2 -0.1, $fn = 12, center = true);
}
