// ============================================================
// Base Compartment Lid - sits on top of open-front, open-top base
// Base width = frame_w, depth = stand_foot_depth
// ============================================================
include <common.scad>

module base_lid() {
    left_ext = panel_rim + panel_inset;
    base_w = frame_w;
    lid_w = base_w - 2 * base_wall - 2 * tol;
    lid_h = stand_foot_depth - base_wall - 2 * tol;
    lid_d = 1.2;
    lip = 1.0;

    difference() {
        union() {
            cube([lid_w, lid_h, lid_d]);
            translate([lip, lip, -lip])
                cube([lid_w - 2 * lip, lid_h - 2 * lip, lip]);
        }

        // Finger pull cutout
        translate([lid_w / 2, lid_h / 2, -lip])
            cylinder(d = 15, h = lid_d + lip, $fn = 30);
    }
}

base_lid();
