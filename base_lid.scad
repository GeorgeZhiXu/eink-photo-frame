// ============================================================
// Base Compartment Lid
// ============================================================
include <common.scad>

module base_lid() {
    slot_total_w = frame_d + wall_thick;  // matches base_stand slot_w
    lid_w = cavity_w - 2 * base_wall - 2 * tol;
    lid_h = stand_foot_depth - slot_total_w - 2 * base_wall - 2 * tol;
    lid_d = 1.5;
    lip = 1.0;

    difference() {
        union() {
            cube([lid_w, lid_h, lid_d]);
            translate([lip, lip, lid_d])
                cube([lid_w - 2 * lip, lid_h - 2 * lip, lip]);
        }

        // Finger pull cutout
        translate([lid_w / 2, lid_h / 2, -0.1])
            cylinder(d = 15, h = lid_d + lip + 0.2, $fn = 30);
    }
}

base_lid();
