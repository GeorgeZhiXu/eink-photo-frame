// ============================================================
// Base / Stand - Open-front, open-back box with angled cut
//
// Printed with left/right/bottom bezels, bezel face down.
// Back wall and standoffs are separate pieces.
// Shallow marker holes (0.2mm) on floor show standoff positions.
//
// Side view:
//          ╱────────────────────
//         ╱                     (no back wall)
//        ╱  angled cut (12°)
//       ╱
//      ╱
//     ╱shelf (panel sits here)
//    ╱
//   ╱───────────────────────────
//       desk surface
// ============================================================
include <common.scad>

module base_stand() {
    compartment_h = max(board_clearance + board_d, battery_d) + 5;
    base_h = base_wall + compartment_h;

    left_ext = panel_rim + panel_inset;
    base_w = frame_w;

    board_x = left_ext + base_wall;
    board_y = 20 - board_hole_edge_y;

    standoff_r = board_hole_dia / 2 + 0.8;
    marker_depth = 0.2;
    e = 0.01;

    hole_positions = [
        [board_hole_edge_x, board_hole_edge_y],
        [board_hole_edge_x + board_hole_h, board_hole_edge_y],
        [board_hole_edge_x, board_hole_edge_y + board_hole_v],
        [board_hole_edge_x + board_hole_h, board_hole_edge_y + board_hole_v]
    ];

    difference() {
        // Base body: round the left and right vertical edges
        // Create rounded XZ cross-section, extrude along Y
        intersection() {
            cube([base_w, stand_foot_depth, base_h]);
            rotate([90, 0, 0])
                translate([0, 0, -stand_foot_depth])
                    linear_extrude(stand_foot_depth)
                        offset(r = corner_r, $fn = 180) offset(r = -corner_r)
                            square([base_w, base_h]);
        }

        // 1. Angled cut at front
        rotate([-stand_angle, 0, 0])
            translate([-e, -stand_foot_depth, -base_h])
                cube([base_w + 2 * e, stand_foot_depth, base_h * 3]);

        // 2. Hollow interior (open front, open back, open top)
        translate([base_wall, -e, base_wall])
            cube([
                base_w - 2 * base_wall,
                stand_foot_depth + 2 * e,
                compartment_h + e
            ]);

        // 3. Standoff marker holes on floor (0.2mm deep)
        for (pos = hole_positions) {
            translate([board_x + pos[0], board_y + pos[1], base_wall - marker_depth])
                cylinder(r = standoff_r, h = marker_depth + e, $fn = 20);
        }
    }
}

base_stand();
