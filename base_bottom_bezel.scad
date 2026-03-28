// ============================================================
// Assembly view: base + bottom bezel + ghost back panel
// All in desk coordinates: X=width, Y=depth, Z=height
// Panel (panel_w) is the reference at X=0
// ============================================================
include <common.scad>
use <base_stand_combined.scad>
use <bezel_top.scad>
use <bezel_bottom.scad>
use <bezel_left.scad>
use <bezel_right.scad>

_slot_w = frame_d + wall_thick;
_left_ext = board_offset_x + tol;  // base is wider on left by this amount

// Base centered under panel (accounting for asymmetric left extension)
// Cavity in base starts at _left_ext from base left edge
// Panel cavity starts at panel_rim from panel left edge
// So base left edge = panel_rim - _left_ext
color("DimGray")
//    translate([panel_rim - _left_ext, 0, 0])
        base_stand_combined();

// Bottom bezel (frame_w wide) centered on panel
// X offset: -(frame_w - panel_w) / 2 = -panel_inset
color("Gold")
//    translate([-panel_inset, 0, 0])
        rotate([90 - stand_angle, 0, 0]) {
//color("Silver") bezel_top();
color("Silver") bezel_bottom();
//color("Silver") bezel_left();
//color("Silver") bezel_right();        
}

