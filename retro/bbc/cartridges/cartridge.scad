use <../../util.scad>;

$fn = 50;
extra = 0.1;

// Rounding/fillet radius and additional margin of subtracted material. The additional margin helps avoid geometry problems.
rr = 2;
ro = rr;

groove_rr = 0.2;
groove_ro = groove_rr;

pcb_lug_rr = 0.5;
pcb_lug_ro = pcb_lug_rr;

// BBCCartridge
//
// component to render, 1=front, 2=back, 3=both
//
// backStyle how the polarisation slot is handled:
//      0 short back,
//      1 realistic indent,
//      2 modern cavity. Use this if printer can't do 1.
//
// topLabelInset include inset for label on top, 0=none
//
// payload_height height of payload, minimum is 51.5 but can be higher
//
// pcbBump 1 to include bump in pcb support as some pcb's have a space for it, 0 for none
//
module BBCCartridge(component = 3, backStyle = 1, topLabelInset = 0, payload_height = 51.5, pcbBump = 1) {

    fullBackConnector = backStyle == 0 ? 0 : 1;
    realisticPolarisationKey = backStyle == 1 ? 1 : 0;
    modernPolarisationCutout = backStyle == 2 ? 1 : 0;

    // internal width in the payload section.
    // Use 140mm for an Electron +1 cart, e.g. I had an RS423 cart which was that wide
    int_payload_width = 86.0;

    int_connector_width = 86.0;
    int_payload_depth = 14.0;
    int_connector_depth = 11.5;
    int_payload_height = payload_height > 51.5 ? payload_height : 51.5;
    int_connector_height = 13.5;

    // Side thicknesses
    front = 2;
    payload_back = 1;
    connector_back = 3.5;
    top = 3;
    side = 2;
    bottom = 1;

    groove_width_extra = 2.0;
    front_back_overlap = 1.0;
    groove_width_overlap = front_back_overlap + groove_width_extra;

    int_front_depth = 4.5;
    front_depth = int_front_depth + front;
    int_payload_back_depth = int_payload_depth - int_front_depth + front_back_overlap;
    int_connector_back_depth = int_connector_depth - int_front_depth + front_back_overlap;
    back_depth = int_payload_back_depth + payload_back;

    // Cartridge dimensions.
    payload_width = int_payload_width + side + side;
    payload_height = top + int_payload_height;

    connector_width = int_connector_width + side + side;
    connector_height = bottom + int_connector_height;

    height = payload_height + bottom + int_connector_height;
    depth = int_payload_depth + front + payload_back;

    upper_extent = height / 2;
    lower_extent = - upper_extent;
    int_payload_upper_extent = upper_extent - top;
    int_payload_lower_extent = lower_extent + int_connector_height + bottom;

    int_connector_right_extent = int_connector_width / 2;
    int_connector_left_extent = - int_connector_right_extent;
    connector_left_extent = int_connector_left_extent - side;
    connector_right_extent = int_connector_right_extent + side;

    // expand payload to left if it's wider than the connector, e.g. said RS423 adaptor
    int_payload_right_extent = int_connector_right_extent;
    int_payload_left_extent = int_payload_right_extent - int_payload_width;
    payload_left_extent = int_payload_left_extent - side;
    payload_right_extent = int_payload_right_extent + side;
    payload_centre = (payload_left_extent + payload_right_extent) / 2;

    front_side = side;
    front_left = front_side;
    front_right = front_side;
    back_side = side;
    back_left = back_side;
    back_right = back_side;

    front_label_width = payload_width - side - side - 3.0;
    front_label_height = 46.0;
    front_label_depth = 1.0;
    front_label_offset_from_bottom = 19.5;
    front_label_centre = payload_centre;
    front_label_left_extent = front_label_centre - front_label_width / 2;

    top_label_width = front_label_width;
    top_label_height = 11.5;
    top_label_depth = front_label_depth;
    top_label_offset_from_front = 2.5;
    top_label_centre = payload_centre;
    top_label_left_extent = top_label_centre - front_label_width / 2;

    groove_width_exposed = 1.5;
    groove_width_normal = groove_width_exposed + front_back_overlap;
    groove_depth = 1.0;

    top_groove_width = groove_width_overlap;
    top_groove_depth = 2.0;

    inner_top_front_cutout_width = int_payload_width;
    inner_top_front_cutout_depth = top_groove_width;
    inner_top_front_cutout_height = top - top_groove_depth;

    inner_payload_front_cutout_height = payload_height - top_groove_depth;
    inner_payload_front_cutout_width = front_side - groove_depth;
    inner_payload_front_cutout_depth = groove_width_overlap;

    inner_connector_front_cutout_height = connector_height;
    inner_connector_front_cutout_width = front_side - groove_depth;
    inner_connector_front_cutout_depth = groove_width_overlap;

    back_cavity_width = 68.0;
    back_cavity_inner_width = 65.0;
    back_cavity_offset_from_inner_left = 9.0;
    back_cavity_inner_offset_from_inner_left = 10.5;
    back_cavity_height = 13.5;
    back_cavity_inner_height = 12.0;
    back_cavity_depth = 1.5;

    inner_back_slope_depth = 2.5;
    inner_back_slope_width = inner_back_slope_depth;
    inner_back_slope_max_offset = 10.5;
    inner_back_slope_min_offset = inner_back_slope_max_offset - inner_back_slope_width;

    inner_back_edge_width = 69.0;
    inner_back_edge_height = 3.0;
    inner_back_edge_depth = 1.5;

    inner_front_edge_width = connector_width - front_side * 2;
    inner_front_edge_height = 3.0;
    inner_front_edge_depth = 1.5;

    edge_connector_cutout_back_depth = 3.0;
    edge_connector_cutout_back_width = 57.5;

    edge_connector_cutout_front_depth = front_back_overlap;
    edge_connector_cutout_front_width = (int_connector_width - edge_connector_cutout_back_width) / 2;

    pcb_back_support_width = 1.2;
    pcb_back_support_depth = back_depth -
        edge_connector_cutout_back_depth;
    pcb_back_support_height = height - int_connector_height - top - bottom;

    pcb_front_support_width = pcb_back_support_width;
    pcb_front_support_depth = int_front_depth;
    pcb_front_support_height = pcb_back_support_height;

    pcb_back_support_bump_width = pcb_front_support_width;
    pcb_back_support_bump_depth = 1.5;
    pcb_back_support_left_bump_height = pcbBump == 1 ? 13.2 : 0.0;
    pcb_back_support_right_bump_height = pcbBump == 1 ? 10.7 : 0.0;
    pcb_back_support_left_bump_offset_from_bottom = 15.1;
    pcb_back_support_right_bump_offset_from_bottom = 17.6;
    pcb_back_support_break_from_bottom = 35.3;    /* 36.45 from the above diagram */
    pcb_back_support_break_height = 13;        /* 11.55 from the above diagram */

    pcb_back_support_top_bump_height = int_payload_height - pcb_back_support_break_from_bottom -
        pcb_back_support_break_height;

    pcb_support_margin = 1.75;
    pcb_support_offset_from_centre = edge_connector_cutout_back_width / 2 - pcb_support_margin;

    pcb_lug_mating_depth = pcb_back_support_bump_depth + 1.0;

    pcb_back_lug_depth = pcb_back_support_depth + pcb_lug_mating_depth;
    pcb_back_lug_inner_radius = 1.0;
    pcb_back_lug_outer_radius = 5.5 / 2;

    pcb_lug_cross_width = 6.7;
    pcb_lug_cross_depth = pcb_back_support_depth + pcb_back_support_bump_depth - pcb_lug_mating_depth;
    pcb_lug_cross_height = 1.4;

    pcb_front_lug_depth = pcb_front_support_depth + pcb_lug_mating_depth;
    pcb_front_lug_inner_radius = pcb_back_lug_outer_radius;
    pcb_front_lug_outer_radius = pow(pow(pcb_lug_cross_width / 2, 2) + pow(pcb_lug_cross_height / 2, 2), 0.5);

    pcb_back_socket_lug_depth = back_depth - front_back_overlap - pcb_lug_mating_depth;

    pcb_lug_offset_from_bottom = 14.35;
    pcb_lug_offset_from_inside = 5.55;

    wide_pcb_lug_offset_from_inside = 6.0;
    wide_pcb_lug_offset_from_bottom = 6.0;

    pcb_width = 84.85; pcb_height = 62.5; pcb_depth = 1;
    edge_connector_width = 56.5; edge_connector_height = 11.85;

    pcb_hole_margin = 0.55;
    pcb_hole_width = 2.2;
    pcb_hole_extra_depth = 0.1;
    pcb_lug_hole_radius = 3.75;

    pcb_left_hole_offset = pcb_back_support_left_bump_offset_from_bottom + pcb_hole_margin;
    pcb_left_hole_height = pcb_back_support_left_bump_height - pcb_hole_margin * 2;
    pcb_left_hole_offset_from_centre = - (pcb_support_offset_from_centre + pcb_back_support_width / 2 - pcb_hole_width /
        2);

    pcb_right_hole_offset = pcb_back_support_right_bump_offset_from_bottom + pcb_hole_margin;
    pcb_right_hole_height = pcb_back_support_right_bump_height - pcb_hole_margin * 2;
    pcb_right_hole_offset_from_centre = - pcb_left_hole_offset_from_centre;

    pcb_hole_depth = pcb_depth + 2 * pcb_hole_extra_depth;
    pcb_hole_start_depth = edge_connector_cutout_back_depth + pcb_hole_extra_depth;

    wide_pcb_width = 138.0; wide_pcb_height = pcb_height; wide_pcb_depth = pcb_depth;
    wide_pcb_hole_depth = pcb_hole_depth;
    wide_pcb_hole_start_depth = pcb_hole_start_depth;

    wide_pcb_lug_hole_radius = 4.0;

    feature_width = 15.0; feature_depth = 7.0; feature_height = 40.0;
    feature_height_offset = 10.0;

    module pcb_support(xdir, bump_height, bump_offset, break_offset, break_height) {

        /*
        Translate the support in the stated direction.
        Since the support is already justified in the direction, the translation
        moves the inner edge of the support to alignment with the end of the
        edge connector cutout and then back by the PCB support margin.
        */

        translate([xdir * pcb_support_offset_from_centre, edge_connector_cutout_back_depth, int_payload_lower_extent]) {
            justify(pcb_back_support_width, pcb_back_support_depth, pcb_back_support_height, xdir, 1, 1) {
                union() {
                    // Underlying support strut
                    difference() {
                        cube([pcb_back_support_width, pcb_back_support_depth, pcb_back_support_height], center = true);

                        cube_at(pcb_back_support_width, pcb_back_support_depth, break_height, 0, 1, 1, 0, -
                        pcb_back_support_depth / 2, - pcb_back_support_height / 2 + break_offset);
                    }

                    // Middle bump
                    if (bump_height > 0) {
                        cube_at(pcb_back_support_bump_width, pcb_back_support_bump_depth, bump_height, 0, - 1, 1, 0, -
                        pcb_back_support_depth / 2, - pcb_back_support_height / 2 + bump_offset);
                    }
                }
            }
        }
    }

    module pcb_lug(xdir) {
        pcb_back_plug_lug_explicit(xdir, int_connector_width / 2 - pcb_lug_offset_from_inside,
        pcb_lug_offset_from_bottom);
    }

    module pcb_back_plug_lug_explicit(xdir, offset_from_centre, offset_from_bottom) {
        translate([payload_centre + xdir * offset_from_centre,
            back_depth,
                int_payload_lower_extent + offset_from_bottom
            ])
            rotate([90, 0, 0])
                difference() {

                    /* Cylinder with cross. */

                    union() {
                        cylinder(h = pcb_back_lug_depth, r = pcb_back_lug_outer_radius);
                        cube_at(pcb_lug_cross_width,
                        pcb_lug_cross_height, pcb_lug_cross_depth,
                        0, 0, 1,
                        0, 0, 0);
                        cube_at(pcb_lug_cross_height,
                        pcb_lug_cross_width, pcb_lug_cross_depth,
                        0, 0, 1,
                        0, 0, 0);
                    }

                    /* Hollowed out by a cylinder. */

                    cylinder(h = pcb_back_lug_depth, r = pcb_back_lug_inner_radius);

                    /* Tapered off for easier connection. */
                    translate([0, 0, pcb_back_lug_depth - pcb_lug_ro])
                        fillet_torus(pcb_back_lug_outer_radius, pcb_lug_rr);
                }
    }

    /* The conventional front "lug" which is actually a socket. */

    module pcb_front_lug(xdir) {
        pcb_socket_lug_explicit(xdir, int_connector_width / 2 - pcb_lug_offset_from_inside,
            - int_front_depth + pcb_front_lug_depth,
        pcb_lug_offset_from_bottom,
        pcb_front_lug_depth, pcb_front_lug_outer_radius, pcb_front_lug_inner_radius);
    }

    module pcb_front_lug_wide(xdir) {
        pcb_socket_lug_explicit(xdir, int_payload_width / 2 - wide_pcb_lug_offset_from_inside,
            - int_front_depth + pcb_front_lug_depth,
        wide_pcb_lug_offset_from_bottom,
        pcb_front_lug_depth, pcb_front_lug_outer_radius, pcb_front_lug_inner_radius);
        pcb_socket_lug_explicit(xdir, int_payload_width / 2 - wide_pcb_lug_offset_from_inside,
            - int_front_depth + pcb_front_lug_depth,
                wide_pcb_height - edge_connector_height - wide_pcb_lug_offset_from_bottom,
        pcb_front_lug_depth, pcb_front_lug_outer_radius, pcb_front_lug_inner_radius);
    }

    /*
    The alternative back "lug" which is actually a socket as well, meaning
    that a cylinder runs from the front surface to the back, with the two
    sections meeting in the middle.
    */

    module pcb_back_socket_lug(xdir) {
        pcb_socket_lug_explicit(xdir, int_connector_width / 2 - pcb_lug_offset_from_inside,
        back_depth,
        pcb_lug_offset_from_bottom,
        pcb_back_socket_lug_depth, pcb_front_lug_outer_radius, pcb_front_lug_inner_radius);
    }

    module pcb_back_socket_lug_wide(xdir) {
        pcb_socket_lug_explicit(xdir, int_payload_width / 2 - wide_pcb_lug_offset_from_inside,
        back_depth,
        wide_pcb_lug_offset_from_bottom,
        pcb_back_socket_lug_depth, pcb_front_lug_outer_radius, pcb_front_lug_inner_radius);
        pcb_socket_lug_explicit(xdir, int_payload_width / 2 - wide_pcb_lug_offset_from_inside,
        back_depth,
                wide_pcb_height - edge_connector_height - wide_pcb_lug_offset_from_bottom,
        pcb_back_socket_lug_depth, pcb_front_lug_outer_radius, pcb_front_lug_inner_radius);
    }

    /* The common implementation of the cylinder socket. */

    module pcb_socket_lug_explicit(xdir, offset_from_centre, depth_offset, offset_from_bottom,
    lug_depth, lug_outer_radius, lug_inner_radius) {

        translate([payload_centre + xdir * offset_from_centre,
            depth_offset,
                int_payload_lower_extent + offset_from_bottom
            ])
            rotate([90, 0, 0])
                difference() {
                    cylinder(h = lug_depth,
                    r = lug_outer_radius);
                    cylinder(h = lug_depth,
                    r = lug_inner_radius);
                }
    }

    /* The holes in the front surface when socket lugs are used. */
    module pcb_front_socket_hole(xdir) {
        pcb_socket_hole_explicit(xdir, int_connector_width / 2 - pcb_lug_offset_from_inside,
            - int_front_depth + extra,
        pcb_lug_offset_from_bottom,
            front + extra * 2, pcb_front_lug_inner_radius);
    }

    module pcb_front_socket_hole_wide(xdir) {
        pcb_socket_hole_explicit(xdir, int_payload_width / 2 - wide_pcb_lug_offset_from_inside,
            - int_front_depth + extra,
        wide_pcb_lug_offset_from_bottom,
            front + extra * 2, pcb_front_lug_inner_radius);
        pcb_socket_hole_explicit(xdir, int_payload_width / 2 - wide_pcb_lug_offset_from_inside,
            - int_front_depth + extra,
                wide_pcb_height - edge_connector_height - wide_pcb_lug_offset_from_bottom,
            front + extra * 2, pcb_front_lug_inner_radius);
    }

    /* The holes in the back surface when socket lugs are used. */
    module pcb_back_socket_hole(xdir) {
        pcb_socket_hole_explicit(xdir, int_connector_width / 2 - pcb_lug_offset_from_inside,
            back_depth + extra,
        pcb_lug_offset_from_bottom,
            payload_back + extra * 2, pcb_front_lug_inner_radius);
    }

    module pcb_socket_hole_explicit(xdir, offset_from_centre, depth_offset, offset_from_bottom,
    hole_depth, hole_radius) {

        translate([payload_centre + xdir * offset_from_centre,
            depth_offset,
                int_payload_lower_extent + offset_from_bottom
            ])
            rotate([90, 0, 0])
                cylinder(h = hole_depth, r = hole_radius);
    }

    if (component == 0) {
        // Front half
        difference() {
            union() {

                cube_at(payload_width, front, payload_height, 0, - 1, 1, payload_centre, - int_front_depth,
                int_payload_lower_extent);

                cube_at(front_left, front_depth, payload_height, - 1, - 1, 1, int_payload_left_extent, 0,
                int_payload_lower_extent);

                cube_at(front_right, front_depth, payload_height, 1, - 1, 1, int_payload_right_extent, 0,
                int_payload_lower_extent);

                cube_at(connector_width, front, connector_height, 0, - 1, - 1, 0, - int_front_depth,
                int_payload_lower_extent);

                cube_at(front_left, front_depth, connector_height, - 1, - 1, - 1, int_connector_left_extent, 0,
                int_payload_lower_extent);

                cube_at(front_right, front_depth, connector_height, 1, - 1, - 1, int_connector_right_extent, 0,
                int_payload_lower_extent);

                cube_at(payload_width, front_depth, top, 0, - 1, 1, payload_centre, 0, int_payload_upper_extent);

                difference() {

                    if (payload_width > connector_width) {
                        cube_at(payload_width, front_depth, bottom, 1, - 1, 1, payload_left_extent, 0, lower_extent +
                            int_connector_height);
                    } else {
                        cube_at(int_connector_width, int_front_depth, bottom, 0, - 1, 1, 0, 0, lower_extent +
                            int_connector_height);
                    }

                    cube_at(edge_connector_cutout_front_width, edge_connector_cutout_front_depth, bottom, 1, - 1, 1,
                    int_connector_left_extent, 0, lower_extent + int_connector_height);

                    cube_at(edge_connector_cutout_front_width, edge_connector_cutout_front_depth, bottom, - 1, - 1, 1,
                    int_connector_right_extent, 0, lower_extent + int_connector_height);
                }

                {
                    cube_at(pcb_front_support_width, pcb_front_support_depth, pcb_front_support_height, - 1, - 1, 1, -
                    pcb_support_offset_from_centre, 0, int_payload_lower_extent);

                    cube_at(pcb_front_support_width, pcb_front_support_depth, pcb_front_support_height, 1, - 1, 1,
                    pcb_support_offset_from_centre, 0, int_payload_lower_extent);

                    pcb_front_lug(- 1);
                    pcb_front_lug(1);
                }
            }

            // Label insets
            union() {
                // Front label
                translate([front_label_left_extent, - front_depth, lower_extent + front_label_offset_from_bottom])
                    cube([front_label_width, front_label_depth, front_label_height]);

                // Top label
                if (topLabelInset == 1) {
                    translate([top_label_left_extent, - front_depth + top_label_offset_from_front, upper_extent -
                        top_label_depth])
                        cube([top_label_width, top_label_height, top_label_depth]);
                }
            }

            // Inner front edge cavity
            translate([inner_front_edge_width / 2, - int_front_depth, lower_extent])
                rotate([0, - 90, 0])
                    linear_extrude(height = inner_front_edge_width)
                        polygon([
                                [- extra, - inner_front_edge_depth],
                                [0, - inner_front_edge_depth],
                                [inner_front_edge_height, 0],
                                [- extra, 0],
                            ]);

            // Inner grooves for the top and sides of the back portion
            cube_at(inner_top_front_cutout_width, inner_top_front_cutout_depth, inner_top_front_cutout_height, 1, - 1, 1
            , int_payload_left_extent, 0, int_payload_upper_extent);

            cube_at(inner_payload_front_cutout_width, inner_payload_front_cutout_depth,
            inner_payload_front_cutout_height, 1, - 1, 1, int_payload_right_extent, 0, int_payload_lower_extent);

            cube_at(inner_payload_front_cutout_width, inner_payload_front_cutout_depth,
            inner_payload_front_cutout_height, - 1, - 1, 1, int_payload_left_extent, 0, int_payload_lower_extent);

            // Cutout to accept the back connector sides (or the floor of the back piece)
            cube_at(inner_connector_front_cutout_width, fullBackConnector ? inner_connector_front_cutout_depth :
                    edge_connector_cutout_front_depth, fullBackConnector ? inner_connector_front_cutout_height : bottom,
            1, - 1, - 1, int_connector_right_extent, 0, int_payload_lower_extent);

            cube_at(inner_connector_front_cutout_width, fullBackConnector ? inner_connector_front_cutout_depth :
                    edge_connector_cutout_front_depth, fullBackConnector ? inner_connector_front_cutout_height : bottom,
            - 1, - 1, - 1, int_connector_left_extent, 0, int_payload_lower_extent);

            // Fillets to round off the edges
            union() {
                translate([payload_left_extent + ro, - front_depth / 2, upper_extent - ro])
                    rotate([0, 0, 180])
                        rotate([90, 0, 0])
                            fillet(rr, front_depth);
                translate([payload_right_extent - ro, - front_depth / 2, upper_extent - ro])
                    rotate([90, 0, 0])
                        fillet(rr, front_depth);

                translate([payload_centre, - front_depth + ro, upper_extent - ro])
                    rotate([0, 0, 180])
                        rotate([0, - 90, 0])
                            fillet(rr, payload_width);

                translate([payload_right_extent - ro, - front_depth + ro, int_payload_lower_extent - bottom - extra])
                    rotate([0, 0, 270])
                        fillet_justified(rr, payload_height + bottom + extra);

                translate([payload_left_extent + ro, - front_depth + ro, int_payload_lower_extent - bottom - extra])
                    rotate([0, 0, 180])
                        fillet_justified(rr, payload_height + bottom + extra);

                translate([connector_right_extent - ro, - front_depth + ro, lower_extent])
                    rotate([0, 0, 270])
                        fillet_partitioned(rr, connector_height - bottom);

                translate([connector_left_extent + ro, - front_depth + ro, lower_extent])
                    rotate([0, 0, 180])
                        fillet_partitioned(rr, connector_height - bottom);
            }
        }
    } else {
        // Back half
        difference() {
            union() {
                cube_at(payload_width, payload_back, payload_height, 0, 1, 1, payload_centre, int_payload_back_depth,
                int_payload_lower_extent);

                cube_at(back_left, back_depth, payload_height, - 1, 1, 1, int_payload_left_extent, 0,
                int_payload_lower_extent);

                cube_at(back_right, back_depth, payload_height, 1, 1, 1, int_payload_right_extent, 0,
                int_payload_lower_extent);

                if (fullBackConnector) {
                    cube_at(connector_width, connector_back, connector_height, 0, 1, - 1, 0, int_connector_back_depth,
                    int_payload_lower_extent);

                    cube_at(back_left, back_depth, connector_height, - 1, 1, - 1, int_connector_left_extent, 0,
                    int_payload_lower_extent);

                    cube_at(back_right, back_depth, connector_height, 1, 1, - 1, int_connector_right_extent, 0,
                    int_payload_lower_extent);
                }

                cube_at(payload_width, back_depth, top, 0, 1, 1, payload_centre, 0, int_payload_upper_extent);

                difference() {
                    cube_at(back_left - groove_depth, groove_width_extra, inner_payload_front_cutout_height, - 1, 1, 1,
                    int_payload_left_extent, - groove_width_extra, int_payload_lower_extent);

                    translate([int_payload_left_extent - groove_ro, - groove_width_extra + groove_ro,
                        int_payload_lower_extent])
                        rotate([0, 0, - 90])
                            fillet_justified(groove_rr, inner_payload_front_cutout_height);
                }

                difference() {
                    cube_at(back_right - groove_depth, groove_width_extra, inner_payload_front_cutout_height, 1, 1, 1,
                    int_payload_right_extent, - groove_width_extra, int_payload_lower_extent);

                    translate([int_payload_right_extent + groove_ro, - groove_width_extra + groove_ro,
                        int_payload_lower_extent])
                        rotate([0, 0, 180])
                            fillet_justified(groove_rr, inner_payload_front_cutout_height);
                }

                if (fullBackConnector) {
                    difference() {
                        cube_at(back_left - groove_depth, groove_width_extra, inner_connector_front_cutout_height, - 1,
                        1, - 1, int_connector_left_extent, - groove_width_extra, int_payload_lower_extent);

                        translate([int_connector_left_extent - groove_ro, - groove_width_extra + groove_ro, lower_extent
                            ])
                            rotate([0, 0, - 90])
                                fillet_partitioned(groove_rr, inner_connector_front_cutout_height + extra);
                    }

                    difference() {
                        cube_at(back_right - groove_depth, groove_width_extra, inner_connector_front_cutout_height, 1, 1
                        , - 1, int_connector_right_extent, - groove_width_extra, int_payload_lower_extent);

                        translate([int_connector_right_extent + groove_ro, - groove_width_extra + groove_ro,
                            lower_extent])
                            rotate([0, 0, 180])
                                fillet_partitioned(groove_rr, inner_connector_front_cutout_height + extra);
                    }
                }

                difference() {
                    cube_at(payload_width - groove_depth * 2, groove_width_extra, top - top_groove_depth, 0, 1, 1,
                    payload_centre, - groove_width_extra, int_payload_upper_extent);

                    translate([payload_centre, - groove_width_extra + groove_ro, int_payload_upper_extent + groove_ro])
                        rotate([0, 0, 180])
                            rotate([0, 90, 0])
                                fillet(groove_rr, payload_width - groove_depth * 2);
                }

                difference() {
                    if (payload_width > connector_width) {

                        difference() {
                            cube_at(payload_width, back_depth, bottom, 1, 1, 1, payload_left_extent, 0, lower_extent +
                                int_connector_height);

                            cube_at(payload_width - connector_width + groove_depth, edge_connector_cutout_front_depth,
                            bottom, 1, 1, 1, payload_left_extent, 0, lower_extent + int_connector_height);
                        }

                    } else {
                        cube_at(connector_width, back_depth, bottom, 0, 1, 1, 0, 0, lower_extent + int_connector_height)
                        ;
                    }

                    cube_at(edge_connector_cutout_back_width, edge_connector_cutout_back_depth, bottom, 0, 1, 1, 0, 0,
                        lower_extent + int_connector_height);
                }

                // PCB supports
                {
                    pcb_support(- 1, pcb_back_support_left_bump_height,
                    pcb_back_support_left_bump_offset_from_bottom,
                    pcb_back_support_break_from_bottom,
                    pcb_back_support_break_height);

                    pcb_support(1, pcb_back_support_right_bump_height,
                    pcb_back_support_right_bump_offset_from_bottom,
                    pcb_back_support_break_from_bottom,
                    pcb_back_support_break_height);

                    pcb_lug(- 1);
                    pcb_lug(1);
                }
            }

            // Label insets
            union() {
                if (topLabelInset == 1) {
                    translate([top_label_left_extent, - front_depth + top_label_offset_from_front, upper_extent -
                        top_label_depth])
                        cube([top_label_width, top_label_height, top_label_depth]);
                }
            }

            union() {
                cube_at(groove_depth, groove_width_normal, payload_height + bottom, 1, 1, - 1, payload_left_extent, 0,
                upper_extent);

                if (fullBackConnector) {
                    cube_at(groove_depth, groove_width_normal, connector_height, 1, 1, 1, connector_left_extent, 0,
                    lower_extent);
                }

                cube_at(groove_depth, groove_width_normal, height, - 1, 1, 0, payload_right_extent, 0, 0);

                if (fullBackConnector) {
                    cube_at(groove_depth, groove_width_normal, connector_height, - 1, 1, 1, connector_right_extent, 0,
                    lower_extent);
                }

                cube_at(payload_width, groove_width_normal, groove_depth, 0, 1, - 1, payload_centre, 0, upper_extent);

                cube_at(payload_width, top_groove_width, top_groove_depth, 0, 1, - 1, payload_centre, -
                groove_width_extra, upper_extent);
            }

            // Back socket holes
            pcb_back_socket_hole(- 1);
            pcb_back_socket_hole(1);

            /* The connector section at the base of the back. */

            if (fullBackConnector) {

                if (realisticPolarisationKey) {
                    intersection() {

                        translate([0, back_depth, lower_extent])
                            linear_extrude(height = back_cavity_height)
                                translate([int_connector_left_extent, 0, 0])
                                    polygon([
                                            [back_cavity_offset_from_inner_left, 0],
                                            [back_cavity_inner_offset_from_inner_left,
                                            - back_cavity_depth],
                                            [back_cavity_inner_offset_from_inner_left +
                                            back_cavity_inner_width,
                                            - back_cavity_depth],
                                            [back_cavity_offset_from_inner_left +
                                            back_cavity_width, 0]
                                        ]);

                        translate([back_cavity_width / 2, back_depth, lower_extent])
                            rotate([0, - 90, 0])
                                linear_extrude(height = back_cavity_width)
                                    polygon([
                                            [- extra, - back_cavity_depth],
                                            [back_cavity_inner_height,
                                            - back_cavity_depth],
                                            [back_cavity_height, 0],
                                            [- extra, 0]
                                        ]);
                    }

                } else if (modernPolarisationCutout) {
                    translate([0, back_depth, lower_extent])
                        linear_extrude(height = back_cavity_height)
                            translate([int_connector_left_extent, 0, 0])
                                polygon([
                                        [back_cavity_offset_from_inner_left, 0],
                                        [inner_back_slope_min_offset,
                                            - connector_back + inner_back_slope_depth],
                                        [inner_back_slope_min_offset, - connector_back],
                                        [int_connector_width - inner_back_slope_min_offset,
                                        - connector_back],
                                        [int_connector_width - inner_back_slope_min_offset,
                                            - connector_back + inner_back_slope_depth],
                                        [back_cavity_offset_from_inner_left +
                                        back_cavity_width, 0]
                                    ]);
                }

                translate([0, int_connector_back_depth, lower_extent])
                    linear_extrude(height = int_connector_height)
                        translate([int_connector_left_extent, 0, 0])
                            polygon([
                                    [0, 0],
                                    [inner_back_slope_max_offset, 0],
                                    [inner_back_slope_min_offset,
                                    inner_back_slope_depth],
                                    [0, inner_back_slope_depth]
                                ]);

                translate([0, int_connector_back_depth, lower_extent])
                    linear_extrude(height = int_connector_height)
                        translate([int_connector_right_extent, 0, 0])
                            polygon([
                                    [0, 0],
                                    [- inner_back_slope_max_offset, 0],
                                    [- inner_back_slope_min_offset,
                                    inner_back_slope_depth],
                                    [0, inner_back_slope_depth]
                                ]);

                translate([inner_back_edge_width / 2,
                        int_connector_back_depth + inner_back_edge_depth, lower_extent])
                    rotate([0, - 90, 0])
                        linear_extrude(height = inner_back_edge_width)
                            polygon([
                                    [- extra, - inner_back_edge_depth],
                                    [inner_back_edge_height, - inner_back_edge_depth],
                                    [0, 0],
                                    [- extra, 0]
                                ]);
            }

            union() {
                translate([payload_left_extent + ro, back_depth / 2, upper_extent - ro])
                    rotate([0, 0, 180])
                        rotate([90, 0, 0])
                            fillet(rr, back_depth);
                translate([payload_right_extent - ro, back_depth / 2, upper_extent - ro])
                    rotate([90, 0, 0])
                        fillet(rr, back_depth);

                translate([payload_centre, back_depth - ro, upper_extent - ro])
                    rotate([0, - 90, 0])
                        fillet(rr, payload_width);

                translate([payload_right_extent - ro, back_depth - ro, int_payload_lower_extent - bottom - extra])
                    fillet_justified(rr, payload_height + bottom + extra);

                translate([payload_left_extent + ro, back_depth - ro, int_payload_lower_extent - bottom - extra])
                    rotate([0, 0, 90])
                        fillet_justified(rr, payload_height + bottom + extra);

                if (fullBackConnector) {
                    translate([connector_right_extent - ro, back_depth - ro, lower_extent])
                        fillet_partitioned(rr, connector_height - bottom);

                    translate([connector_left_extent + ro, back_depth - ro, lower_extent])
                        rotate([0, 0, 90])
                            fillet_partitioned(rr, connector_height - bottom);
                }

                translate([payload_left_extent + groove_depth + groove_ro, - groove_width_extra + groove_ro,
                        int_payload_lower_extent - extra])
                    rotate([0, 0, 180])
                        fillet_justified(groove_rr, inner_payload_front_cutout_height + extra);

                translate([payload_right_extent - groove_depth - groove_ro, - groove_width_extra + groove_ro,
                        int_payload_lower_extent - extra])
                    rotate([0, 0, - 90])
                        fillet_justified(groove_rr, inner_payload_front_cutout_height + extra);

                translate([connector_left_extent + groove_depth + groove_ro, - groove_width_extra + groove_ro,
                    lower_extent])
                    rotate([0, 0, 180])
                        fillet_partitioned(groove_rr, inner_connector_front_cutout_height);

                translate([connector_right_extent - groove_depth - groove_ro, - groove_width_extra + groove_ro,
                    lower_extent])
                    rotate([0, 0, - 90])
                        fillet_partitioned(groove_rr, inner_connector_front_cutout_height);

                translate([payload_centre, - groove_width_extra + groove_ro, int_payload_upper_extent +
                    inner_top_front_cutout_height - groove_ro])
                    rotate([0, 0, 180])
                        rotate([0, - 90, 0])
                            fillet(groove_rr, payload_width - groove_depth * 2);
            }
        }
    }
}
