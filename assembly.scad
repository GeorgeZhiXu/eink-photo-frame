// ============================================================
// Assembly view: base + bottom bezel + ghost back panel
// All in desk coordinates: X=width, Y=depth, Z=height
// Panel (panel_w) is the reference at X=0
// ============================================================
include <common.scad>
use <base_stand.scad>
use <bezel_bottom.scad>

_slot_w = frame_d + wall_thick;

// Base (cavity_w wide) centered under panel
// X offset: (panel_w - cavity_w) / 2 = panel_rim
color("DimGray")
    translate([panel_rim, 0, 0])
        base_stand();

// Bottom bezel (frame_w wide) centered on panel
// X offset: -(frame_w - panel_w) / 2 = -panel_inset
color("Gold")
    translate([-panel_inset, _slot_w * cos(stand_angle), 0])
        rotate([90 - stand_angle, 0, 0])
            bezel_bottom();

// Ghost back panel (panel_w wide) at X=0
_panel_y = (_slot_w - frame_d) * cos(stand_angle) + channel_tol;
%translate([0, _panel_y, 0])
    rotate([-stand_angle, 0, 0])
        cube([panel_w, frame_d, 280]);
