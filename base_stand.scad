// ============================================================
// Base / Stand - Open-front box with angled cut
//
// Board is flipped (FPC bends backward), back edge faces back wall:
//   LEFT → [USB-C] [btn1] [btn2] [btn3] [reset] [off/on] → RIGHT
//
// Component heights from board surface (standoff top):
//   USB-C: 3.2mm,  Buttons: 1.8mm,  Switch: 3.0mm
// ============================================================
include <common.scad>

module base_stand() {
    compartment_h = max(board_clearance + board_d, battery_d) + 5;
    base_h = base_wall + compartment_h;

    // Left wall wider to accommodate board 1mm offset from display
    left_ext = board_offset_x + tol;
    base_w = cavity_w + left_ext;

    // Board position in base coords
    board_x = base_wall;
    // Y: front hole center at 18mm from base front edge (y=0)
    // Front hole is at board_hole_edge_y from board front edge
    board_y = 18 - board_hole_edge_y;

    standoff_h = 6.2;   // tallest component ~5.8mm + 0.4mm clearance
    standoff_r = board_hole_dia / 2 + 0.8;
    screw_hole_r = board_hole_dia / 2;
    e = 0.01;

    // Component X positions from board left edge
    // (board is flipped, measured from left hole center)
    left_hole_from_edge = board_hole_edge_x;  // 2.4mm
    usb_x   = left_hole_from_edge + 11.4;     // 13.8mm
    btn1_x  = usb_x + 17.4;                   // 31.2mm
    btn2_x  = btn1_x + 9.2;                   // 40.4mm
    btn3_x  = btn2_x + 9.8;                   // 50.2mm
    reset_x = btn3_x + 9.6;                   // 59.8mm
    sw_off_x = reset_x + 9;                   // 68.8mm
    sw_on_x  = reset_x + 11;                  // 70.8mm
    sw_center_x = (sw_off_x + sw_on_x) / 2;  // 69.8mm

    // Component Z positions: board is upside down, components hang BELOW standoff top
    // Standoff top = board component-side surface
    board_surface_z = base_wall + standoff_h;
    usb_z    = board_surface_z - 3.2;    // USB-C center: 3.2mm below board surface
    btn_z    = board_surface_z - 1.8;    // button center: 1.8mm below board surface
    switch_z = board_surface_z - 3.0;    // switch center: 3.0mm below board surface

    // USB-C port (rounded rectangle / stadium shape)
    usb_port_w = 8.94 + 0.4;   // standard + clearance
    usb_port_h = 3.26 + 0.4;   // standard + clearance
    usb_port_r = usb_port_h / 2 - 0.01; // nearly fully rounded (avoid zero-height collapse)

    // Switch: 1.6mm square dial that slides between off and on positions
    sw_dial = 1.6 + 0.4;   // dial size + clearance
    sw_travel = sw_on_x - sw_off_x;  // 2.2mm travel distance
    sw_slot_w = sw_travel + sw_dial;  // slot width = travel + dial
    sw_slot_h = sw_dial;              // slot height = dial size

    difference() {
        cube([base_w, stand_foot_depth, base_h]);

        // 1. Angled cut at front
        translate([left_ext, 0, 0])
            rotate([-stand_angle, 0, 0])
                translate([-left_ext - e, -stand_foot_depth, -base_h])
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
                    offset(r = usb_port_r, $fn = 40)
                        offset(r = -usb_port_r)
                            square([usb_port_w, usb_port_h], center = true);

        // 4. Button holes (back wall) - btn1, btn2, btn3, reset
        // Actual buttons are 2.4mm round + clearance
        btn_hole_d = 2.4 + 0.4;
        button_xs = [btn1_x, btn2_x, btn3_x, reset_x];
        for (bx = button_xs) {
            translate([board_x + bx, stand_foot_depth - base_wall, btn_z])
                rotate([-90, 0, 0])
                    cylinder(d = btn_hole_d, h = base_wall + e, $fn = 20);
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

    for (pos = hole_positions) {
        translate([board_x + pos[0], board_y + pos[1], base_wall])
            difference() {
                cylinder(r = standoff_r, h = standoff_h, $fn = 20);
                cylinder(r = screw_hole_r, h = standoff_h + e, $fn = 20);
            }
    }
}

base_stand();
