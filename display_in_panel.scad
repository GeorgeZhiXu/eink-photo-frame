// ============================================================
// Display fitted into the back panel
// Shows how the glass sits in the cavity
// ============================================================
include <common.scad>
use <back_panel_bottom.scad>
use <back_panel_top.scad>

// Back panel bottom
color("Pink")
    back_panel_bottom();

// Back panel top
color("Red")
    back_panel_top();

//// Display glass (ghost)
//%translate([panel_rim, bottom_rim, back_thick])
//    color("LightBlue", 0.5)
//        cube([glass_w, glass_h, display_d]);
//
//// FPC ribbon cable (ghost)
//%translate([(panel_w - fpc_w) / 2 + fpc_offset_x, bottom_rim, back_thick])
//    color("Orange", 0.5)
//        cube([fpc_w, 3, 0.3]);
