/*
 * openSCAD Common features
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

/*
 * Bolt sizes - these are for the holes hence +0.25mm, measurements in radius
 */
M4=2.25;
M5=2.75;
M6=3.25;

/*
 * Raspberry PI Specification
 */
// Dimensions of a HAT
PIHAT_WIDTH=65;
PIHAT_HEIGHT=56.5;

// Edge radius
PIHAT_EDGE_RADIUS=3;

// Hole spacing, center-to-center
PIHAT_WIDTH_HOLE=58;
PIHAT_DEPTH_HOLE=49;

// Hole diameter on HAT as per spec
PIHAT_HOLE_DIAM=2.75;

// Max diameter of hole PAD on HAT as per spec
PIHAT_HOLE_PAD_DIAM=6.2;

// Hole offset from HAT corners
PIHAT_OFFSET_X=3.5;
PIHAT_OFFSET_Y=3.5;

// PI dimensions. A+ is same size as the HAT, B+, 2B, 3B are wider by 25mm
PI_A_WIDTH=PIHAT_WIDTH;
PI_A_HEIGHT=PIHAT_HEIGHT;

PI_B_WIDTH=85;
PI_B_HEIGHT=PIHAT_HEIGHT;

PI_Z_WIDTH=65;
PI_Z_HEIGHT=30;

// The Camera/DSI slot dimensions
PI_CSI_WIDTH=17;
PI_CSI_HEIGHT=2;

// Position of CSI from bottom left
PI_CSI_OFFSET_X=45;
PI_CSI_OFFSET_Y=11.5;

// Position of DSI from bottom left
PI_DSI_OFFSET_X=5;
PI_DSI_OFFSET_Y=PIHAT_HEIGHT/2;

// Position of GPIO connector from Top Left mounting hole
PI_GPIO_OFFSET_X=29;
PI_GPIO_OFFSET_Y=0;
PI_GPIO_WIDTH=PIHAT_WIDTH_HOLE-PIHAT_HOLE_DIAM-1;
PI_GPIO_DEPTH=12;
PI_GPIO_HEIGHT=5;
