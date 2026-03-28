// ============================================================
// Base Back Wall - separate piece, slides into base from above
//
// Contains USB-C port, button holes, and on/off switch slot.
// Fits between the left and right base walls.
//
// Board is flipped (components face down), back edge faces this wall:
//   LEFT → [USB-C] [btn1] [btn2] [btn3] [reset] [off/on] → RIGHT
// ============================================================
include <common.scad>

module base_back_wall() {
    compartment_h = max(board_clearance + board_d, battery_d) + 5;
    base_h = base_wall + compartment_h;
    left_ext = panel_rim + panel_inset;
    base_w = frame_w;

    // Wall dimensions: fits between left and right inner walls
    wall_w = base_w - 2 * base_wall - 2 * tol;
    wall_h = base_h - base_wall - tol;  // sits on floor, up to top
    wall_d = base_wall;

    board_x = left_ext + base_wall;
    board_y = 20 - board_hole_edge_y;
    standoff_h = 6.2;

    e = 0.01;
    hole_tol = 0.8;

    // Board X in wall coords (wall starts at base_wall + tol from base left)
    bx_offset = board_x - base_wall - tol;

    left_hole_from_edge = board_hole_edge_x;
    usb_x   = left_hole_from_edge + 11.8;
    btn1_x  = left_hole_from_edge + 28.8;
    btn2_x  = left_hole_from_edge + 38;
    btn3_x  = left_hole_from_edge + 47.4;
    reset_x = left_hole_from_edge + 57;
    sw_off_x = left_hole_from_edge + 65.6;
    sw_on_x  = left_hole_from_edge + 67.8;
    sw_center_x = (sw_off_x + sw_on_x) / 2;

    // Z positions in wall coords (wall bottom = base floor + base_wall)
    board_surface_z = base_wall + standoff_h;  // relative to wall bottom
    usb_z    = board_surface_z - 2.9;
    btn_z    = board_surface_z - 2.3;
    switch_z = board_surface_z - 2.7;

    usb_port_w = 8.94 + hole_tol;
    usb_port_h = 3.26 + hole_tol;
    usb_port_r = usb_port_h / 2 - 0.01;

    sw_dial = 1.6 + hole_tol;
    sw_travel = sw_on_x - sw_off_x;
    sw_slot_w = sw_travel + sw_dial;
    sw_slot_h = sw_dial;

    btn_hole_d = 2.4 + hole_tol;

    difference() {
        cube([wall_w, wall_d, wall_h]);

        // USB-C port (rounded rectangle)
        translate([bx_offset + usb_x, 0, usb_z])
            rotate([-90, 0, 0])
                linear_extrude(wall_d + e)
                    offset(r = usb_port_r, $fn = 40)
                        offset(r = -usb_port_r)
                            square([usb_port_w, usb_port_h], center = true);

        // Button holes
        button_xs = [btn1_x, btn2_x, btn3_x, reset_x];
        for (bx = button_xs) {
            translate([bx_offset + bx, 0, btn_z])
                rotate([-90, 0, 0])
                    cylinder(d = btn_hole_d, h = wall_d + e, $fn = 20);
        }

        // On/off switch slot
        translate([bx_offset + sw_center_x - sw_slot_w / 2, 0, switch_z - sw_slot_h / 2])
            cube([sw_slot_w, wall_d + e, sw_slot_h]);
    }
}

base_back_wall();
