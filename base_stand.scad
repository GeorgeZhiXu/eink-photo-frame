// ============================================================
// Base / Stand - Open-front box with angled cut
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
// - Angled cut at front creates shelf for panel to lean at 12°
// - Open front: bottom bezel attaches to close it and hold the panel
// - Open top: lid is separate piece
// - Board screwed to floor near back wall, left-aligned with display
// - Button holes + USB-C on back wall
// ============================================================
include <common.scad>

module base_stand() {
    compartment_h = max(board_clearance + board_d, battery_d) + 5;
    base_h = base_wall + compartment_h;

    board_x = base_wall;
    board_y = stand_foot_depth - base_wall - board_h;
    standoff_h = 4;
    standoff_r = 2.5;
    screw_hole_r = 1.0;
    e = 0.01;

    difference() {
        cube([cavity_w, stand_foot_depth, base_h]);

        // 1. Angled cut at front (creates shelf for panel)
        rotate([-stand_angle, 0, 0])
            translate([-e, -stand_foot_depth, -base_h])
                cube([cavity_w + 2 * e, stand_foot_depth, base_h * 3]);

        // 2. Hollow interior (open front and top)
        translate([base_wall, -e, base_wall])
            cube([
                cavity_w - 2 * base_wall,
                stand_foot_depth - base_wall + e,
                compartment_h + e
            ]);

        // 3. Button holes on back wall
        for (i = [0 : button_count - 1]) {
            bx = board_x + board_w / 2
                 + (i - (button_count - 1) / 2) * button_spacing;
            translate([bx, stand_foot_depth - base_wall, base_wall + standoff_h + board_d / 2])
                rotate([-90, 0, 0])
                    cylinder(d = button_dia + 1, h = base_wall + e, $fn = 20);
        }

        // 4. USB-C port on back wall
        usb_w = 12;
        usb_h = 7;
        translate([board_x + board_w + 5, stand_foot_depth - base_wall, base_wall + 3])
            cube([usb_w, base_wall + e, usb_h]);
    }

    // Board standoffs (4 corners, screw holes)
    for (dx = [5, board_w - 5]) {
        for (dy = [5, board_h - 5]) {
            translate([board_x + dx, board_y + dy, base_wall])
                difference() {
                    cylinder(r = standoff_r, h = standoff_h, $fn = 20);
                    cylinder(r = screw_hole_r, h = standoff_h + e, $fn = 20);
                }
        }
    }
}

base_stand();
