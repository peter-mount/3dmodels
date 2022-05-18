int_payload_height = 51.5;
pcbBump = 1;
include <cartridge.scad>;

// Hooks into BBCCartridge
module frontLug() {
    for (xdir = [- 1, 1]) {
        offset_from_centre = int_connector_width / 2 - pcb_lug_offset_from_inside;

        pcb_front_plug(
            payload_centre + xdir * offset_from_centre,
            - int_front_depth + pcb_front_lug_depth,
            int_payload_lower_extent + pcb_lug_offset_from_bottom,
        pcb_front_lug_depth,
        pcb_front_lug_outer_radius,
        pcb_front_lug_inner_radius);
    }
}

module backLug() {
    for (xdir = [- 1, 1]) {
        offset_from_centre = int_connector_width / 2 - pcb_lug_offset_from_inside;

        pcb_back_plug(payload_centre + xdir * offset_from_centre,
            int_payload_lower_extent + pcb_lug_offset_from_bottom);
    }
}

module backHole() {
    for (xdir = [- 1, 1]) {
        offset_from_centre = int_connector_width / 2 - pcb_lug_offset_from_inside;

        pcb_back_hole(payload_centre + xdir * offset_from_centre,
            int_payload_lower_extent + pcb_lug_offset_from_bottom,
            payload_back + extra * 2);
    }
}

BBCCartridge(component = 0);
translate([100, 0, 0]) BBCCartridge(component = 1);
