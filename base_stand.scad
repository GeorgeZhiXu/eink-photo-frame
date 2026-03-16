// ============================================================
// Base / Stand - Rectangle with angled corner cut
//
// Side view:
//          ╱────────────────────┐
//         ╱                     │
//        ╱  angled cut (12°)    │
//       ╱                       │
//      ╱                        │
//     ╱shelf (panel sits here)  │
//    ╱                          │
//   ╱───────────────────────────┘
//       desk surface
//
// Back panel sits on the front shelf, leans against the angle.
// Bottom bezel clips onto front to lock the panel in.
// ============================================================
include <common.scad>

module base_stand() {
    // Slot at front for back panel
    slot_w      = frame_d + wall_thick;  // panel thickness + clearance
    panel_rest  = base_wall;                   // shelf height for panel

    // Base dimensions
    base_depth  = stand_foot_depth;
    compartment_h = max(board_clearance + board_d, battery_d) + 5;
    base_h      = base_wall + compartment_h + base_wall;

    // The angled cut starts from the shelf step (y=slot_w, z=panel_rest)
    // and goes up at stand_angle from vertical. No vertical front edge.

    difference() {
        // Solid rectangular base
        cube([cavity_w, base_depth, base_h]);

        // 1. Angled cut starting from shelf step (y=slot_w, z=panel_rest)
        //    No vertical front edge - angle goes directly from shelf step to top
        translate([0, slot_w * cos(stand_angle), 0])
            rotate([-stand_angle, 0, 0])
                translate([-0.1, -2 * slot_w, -3])
                    cube([cavity_w + 0.2, 2 * slot_w , base_h * 2]);

        // Interior compartment for board + battery
        translate([base_wall, slot_w + base_wall, base_wall])
            cube([
                cavity_w - 2 * base_wall,
                base_depth - slot_w - 2 * base_wall,
                compartment_h
            ]);

        // FPC cable routing: from slot into compartment (offset 2mm right)
        translate([(cavity_w - fpc_slot_w) / 2 + fpc_offset_x, 0, panel_rest])
            cube([fpc_slot_w, slot_w + base_wall + 1, fpc_slot_h + 2]);

        // Button access holes (top surface, over board area)
        board_x = (cavity_w - board_w) / 2;
        board_y = slot_w + base_wall + 10;
        for (i = [0 : button_count - 1]) {
            bx = board_x + board_w / 2
                 + (i - (button_count - 1) / 2) * button_spacing;
            by = board_y + board_h - 5;
            translate([bx, by, -0.1])
                cylinder(d = button_dia + 1, h = base_h + 0.2, $fn = 20);
        }

        // USB-C port access (left side wall)
        usb_w = 12;
        usb_h = 7;
        translate([-0.1, slot_w + base_wall + 15, base_wall + 3])
            cube([base_wall + 0.2, usb_w, usb_h]);

        // Ventilation slots on bottom
        vent_count = 4;
        vent_w = 30;
        for (i = [0 : vent_count - 1]) {
            translate([
                cavity_w / 2 - vent_w / 2,
                slot_w + 15 + i * 15,
                -0.1
            ])
                cube([vent_w, 2, base_wall + 0.2]);
        }
    }

    // Board standoffs inside compartment
    board_x = (cavity_w - board_w) / 2;
    board_y = slot_w + base_wall + 10;
    standoff_h = 4;
    standoff_r = 2.5;
    for (dx = [5, board_w - 5]) {
        for (dy = [5, board_h - 5]) {
            translate([board_x + dx, board_y + dy, base_wall])
                difference() {
                    cylinder(r = standoff_r, h = standoff_h, $fn = 20);
                    translate([0, 0, -0.1])
                        cylinder(r = 1.0, h = standoff_h + 0.2, $fn = 20);
                }
        }
    }
}

base_stand();
