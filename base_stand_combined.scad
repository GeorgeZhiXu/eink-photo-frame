// ============================================================
// Base / Stand - Combined single piece (from commit 7063884)
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
// - Open front: bottom bezel attaches to hold the panel
// - Open top: lid is separate piece
// - Left wall aligns with bezel left edge (room for battery connector)
// - Angled cut at front creates 12° shelf for panel
//
// Board is flipped (components face down), back edge faces back wall:
//   LEFT → [USB-C] [btn1] [btn2] [btn3] [reset] [off/on] → RIGHT
//
// Component heights from board surface (standoff top):
//   USB-C: 2.9mm,  Buttons: 2.3mm,  Switch: 2.7mm
//
// Back wall cutouts (left to right):
//   USB-C port (rounded rect) | 4 button holes | on/off switch slot
// ============================================================
include <common.scad>

module base_stand_combined() {
    compartment_h = max(board_clearance + board_d, battery_d) + 5;
    base_h = base_wall + compartment_h;

    left_ext = board_offset_x + batterh_wire_d + tol;
    base_w = cavity_w + left_ext;

    board_x = left_ext + base_wall;
    board_y = 24 - board_hole_edge_y;  // front hole center at 20mm from base front

    standoff_h = 6.2;
    standoff_r = board_hole_dia / 2 + 0.8;
    screw_hole_r = board_hole_dia / 2;
    e = 0.01;
    hole_tol = 0.8;

    // Component X positions from board left edge
    left_hole_from_edge = board_hole_edge_x;
    usb_x   = left_hole_from_edge + 11.8;
    btn1_x  = left_hole_from_edge + 28.8;
    btn2_x  = left_hole_from_edge + 38;
    btn3_x  = left_hole_from_edge + 47.4;
    reset_x = left_hole_from_edge + 57;
    sw_off_x = left_hole_from_edge + 65.6;
    sw_on_x  = left_hole_from_edge + 67.8;
    sw_center_x = (sw_off_x + sw_on_x) / 2;

    // Component Z positions (board upside down, components below standoff top)
    board_surface_z = base_wall + standoff_h;
    usb_z    = board_surface_z - 2.9;
    btn_z    = board_surface_z - 2.3;
    switch_z = board_surface_z - 2.7;

    // USB-C port (rounded rectangle)
    usb_port_w = 8.94 + hole_tol;
    usb_port_h = 3.26 + hole_tol;
    usb_port_r = usb_port_h / 2 - 0.01;

    // On/off switch slot
    sw_dial = 1.6 + hole_tol;
    sw_travel = sw_on_x - sw_off_x;
    sw_slot_w = sw_travel + sw_dial;
    sw_slot_h = sw_dial;

    difference() {
        // Base body: round the left and right vertical edges
        intersection() {
            cube([base_w, stand_foot_depth, base_h]);
            rotate([90, 0, 0])
                translate([0, 0, -stand_foot_depth])
                    linear_extrude(stand_foot_depth)
                        offset(r = corner_r) offset(r = -corner_r)
                            square([base_w, base_h]);
        }

        // 1. Angled cut at front
        rotate([-stand_angle, 0, 0])
            translate([-e, -stand_foot_depth, -base_h])
                cube([base_w + 2 * e, stand_foot_depth, base_h * 3]);

        // 2. Hollow interior (open front and top)
        translate([base_wall, -e, base_wall])
            cube([
                base_w - 2 * base_wall,
                stand_foot_depth - base_wall + e,
                compartment_h + e
            ]);

        // 3. USB-C port (back wall, rounded rectangle)
        translate([board_x + usb_x, stand_foot_depth - base_wall, usb_z])
            rotate([-90, 0, 0])
                linear_extrude(base_wall + e)
                    offset(r = usb_port_r)
                        offset(r = -usb_port_r)
                            square([usb_port_w, usb_port_h], center = true);

        // 4. Button holes (back wall)
        btn_hole_d = 2.4 + hole_tol;
        button_xs = [btn1_x, btn2_x, btn3_x, reset_x];
        for (bx = button_xs) {
            translate([board_x + bx, stand_foot_depth - base_wall, btn_z])
                rotate([-90, 0, 0])
                    cylinder(d = btn_hole_d, h = base_wall + e);
        }

        // 5. On/off switch slot (back wall)
        translate([board_x + sw_center_x - sw_slot_w / 2,
                   stand_foot_depth - base_wall,
                   switch_z - sw_slot_h / 2])
            cube([sw_slot_w, base_wall + e, sw_slot_h]);
    }

    // Board standoffs at exact hole positions
    hole_positions = [
        [board_hole_edge_x, board_hole_edge_y],
        [board_hole_edge_x + board_hole_h, board_hole_edge_y],
        [board_hole_edge_x, board_hole_edge_y + board_hole_v],
        [board_hole_edge_x + board_hole_h, board_hole_edge_y + board_hole_v]
    ];

    fillet_r = 2.5;  // fillet radius at standoff base
    for (pos = hole_positions) {
        translate([board_x + pos[0], board_y + pos[1], base_wall])
            difference() {
                union() {
                    // Main standoff cylinder
                    cylinder(r = standoff_r, h = standoff_h);
                    // Fillet: smooth taper from wider base to standoff diameter
                    // Uses rotate_extrude of a quarter-circle profile
                    rotate_extrude()
                        translate([standoff_r, 0, 0])
                            intersection() {
                                square([fillet_r, fillet_r]);
                                difference() {
                                    square([fillet_r, fillet_r]);
                                    translate([fillet_r, fillet_r])
                                        circle(r = fillet_r);
                                }
                            }
                }
                // Screw hole through everything
                translate([0, 0, -e])
                    cylinder(r = screw_hole_r, h = standoff_h + fillet_r + 2 * e);
            }
    }
}

base_stand_combined();
