/*
 * Miscelaneous modules used by other models
 */

$fn = 50;

extra = 0.1;

// A fillet performs rounding using a quarter segment of a cylinder.
module fillet(r, h) {
    translate([0, 0, - h / 2])
        difference() {
            cube([r + extra, r + extra, h + extra]);
            cylinder(r = r, h = h);
        }
}

/* A fillet justified using the axes. */

module fillet_justified(r, h) {
    difference() {
        cube([r + extra, r + extra, h + extra]);
        cylinder(r = r, h = h);
    }
}

/* A justified fillet with the extra material below the y-axis. */

module fillet_partitioned(r, h) {
    difference() {
        translate([0, 0, - extra])
            cube([r + extra, r + extra, h + extra]);
        cylinder(r = r, h = h);
    }
}

module fillet_torus(radius, rounding) {
    difference() {
        cube_at((radius + extra) * 2, (radius + extra) * 2, rounding + extra,
        0, 0, 1,
        0, 0, 0);
        union() {
            rotate_extrude(convexity = 10)
                translate([radius - rounding, 0, 0])
                    circle(r = rounding);
            cylinder(r = radius - rounding, h = rounding);
        }
    }
}

/*
Justify an object of the given dimensions, according to the given
factors (where 1 indicates moving the object to the positive side of an
axis, and -1 indicates moving it to the negative side of an axis).

NOTE: child should eventually be replaced by children.
*/
module justify(width, depth, height, wdir, ddir, hdir) {
    translate([
                wdir * width / 2,
                ddir * depth / 2,
                hdir * height / 2])
        children();
}

/*
Make a cuboid of the given dimensions, justifying it according to the given
factors, and moving it to the specified coordinates.

NOTE: Usage of justify within this module will not work due to recursion
NOTE: limitations in openscad, potentially removed in more recent
NOTE: releases. Thus, the justify transform is merged in here.
*/
module cube_at(width, depth, height, wdir, ddir, hdir, x, y, z) {
    translate([
            x + wdir * width / 2,
            y + ddir * depth / 2,
            z + hdir * height / 2])
        cube([width, depth, height], center = true);
}
