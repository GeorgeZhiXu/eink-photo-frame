// ============================================================
// Debug: Bottom bezel cross-section profile
//
// Shows a 2D cross-section cut through the middle of the
// bottom bezel (at X = frame_w/2), projected onto the YZ plane.
//
// Y axis = bezel width direction (outer edge → window)
// X axis = depth direction (back → front)
//
// Expected profile (bottom to top):
//   outer_wall (2mm, full height) | channel (1.2mm, full depth) | lip (10.3mm, 0.3mm thick)
//   With bezel face (2.4mm) on top of the lip zone
// ============================================================
include <common.scad>
use <bezel_bottom.scad>

linear_extrude(1)
projection(cut = true)
    rotate([0, 90, 0])
        translate([-frame_w / 2, 0, 0])
            bezel_bottom();
