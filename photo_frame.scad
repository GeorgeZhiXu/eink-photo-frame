// ============================================================
// Photo Frame for 13.3" Spectra 6 E-Ink Display
// All parts laid flat for overview - no overlaps
// ============================================================
include <common.scad>

use <bezel_top.scad>
use <bezel_bottom.scad>
use <bezel_left.scad>
use <bezel_right.scad>
use <back_panel_top.scad>
use <back_panel_bottom.scad>
use <base_stand.scad>
use <base_lid.scad>

gap = 15;

// Row 1 (y=0): Bezel top + bottom side by side
row1_y = 0;
color("Silver")
    translate([0, row1_y, 0])
        bezel_top();

color("Silver")
    translate([frame_w + gap, row1_y, 0])
        bezel_bottom();

// Row 2: Bezel left + right
row2_y = -(frame_h + gap);
color("LightSlateGray")
    translate([0, row2_y, 0])
        bezel_left();

color("LightSlateGray")
    translate([frame_w + gap, row2_y, 0])
        bezel_right();

// Row 3: Back panel bottom (large, 250mm) + back panel top (small, ~60mm)
row3_y = -(2 * frame_h + 2 * gap);
color("SlateGray")
    translate([0, row3_y, 0])
        back_panel_bottom();

color("DimGray")
    translate([frame_w + gap, row3_y, 0])
        back_panel_top();

// Row 4: Base stand + lid
row4_y = -(2 * frame_h + back_split_y + 3 * gap);
color("Gray")
    translate([0, row4_y, 0])
        base_stand();

color("LightGray")
    translate([frame_w + gap, row4_y, 0])
        base_lid();
