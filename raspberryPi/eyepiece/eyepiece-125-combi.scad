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

include <eyepiece.scad>

eyepiece(1.25,3);
