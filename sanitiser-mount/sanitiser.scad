/*
 Hand sanitiser holder
 */


width = 90;
depth = width;
height = 150;


//cube([width,5,height]);
//cube([width,depth,5]);


difference() {
    panel(width, 5, height);

    // Strap
    translate([(width / 2) - 20, - 1, 40]) {
        cube([40, 2.5, 15]);
        for (x = [0, 35]) {
            translate([x, 0, 0]) cube([5, 10, 15]);
        }
    }

    // Mount
    translate([(width / 2), - 1, height - 30]) {
        rotate([- 90, 0, 0]) {
            cylinder(r = 3, h = 10, $f1 = 5);
            translate([0, 8, 0]) cylinder(r = 6, h = 10, $f1 = 5);
            translate([- 3, 0, 0]) cube([6, 6, 10]);
        }
    }
    translate([width - 20, 5, height / 2]) rotate([90, 0, 180]) {
        translate([5, 7, 0]) text("Area51");
        translate([0, -7, 0]) text("Sanitiser");
    }

}

translate([0, 0, 20]) rotate([- 90, 0, 0]) panel(width, 5, depth);

translate([5, 0, 15]) rotate([- 90, 0, 0]) panel(width - 10, 10, 20);
translate([15, 0, 5]) strut(5, depth - 10, 15);
translate([width - 20, 0, 5]) strut(5, depth - 10, 15);
translate([(width / 2) - 2.5, 0, 5]) strut(5, depth - 10, 15);

module panel(w, d, h) {
    hull() {
        cube([w, d, h - 10]);
        translate([10, 0, h - 10]) {
            cube([w - 20, d, 10]);
            rotate([- 90, 0, 0]) cylinder(r = 10, h = d, $f1 = 3);
        }
        translate([w - 10, 0, h - 10]) rotate([- 90, 0, 0]) cylinder(r = 10, h = d, $f1 = 3);
    }
}

module strut(w, d, h) {
    hull() {
        cube([w, d - 5, h]);
        translate([0, d - 5, 10]) difference() {
            rotate([90, 0, 90]) cylinder(r = 10, h = 5, $f1 = 3);
            translate([- 3, - 10, 5]) cube([10, 20, 5]);
        }
    }
}
