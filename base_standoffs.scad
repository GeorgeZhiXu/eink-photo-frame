// ============================================================
// Board Standoffs - 4 separate cylinders with screw holes
// Glue into base at marker positions, or attach to lid
// ============================================================
include <common.scad>

module base_standoffs() {
    standoff_h = 6.2;
    standoff_r = board_hole_dia / 2 + 0.8;
    screw_hole_r = board_hole_dia / 2;
    e = 0.01;

    // Lay out 4 standoffs in a row for printing
    gap = 5;
    for (i = [0 : 3]) {
        translate([i * (standoff_r * 2 + gap), 0, 0])
            difference() {
                cylinder(r = standoff_r, h = standoff_h, $fn = 20);
                cylinder(r = screw_hole_r, h = standoff_h + e, $fn = 20);
            }
    }
}

base_standoffs();
