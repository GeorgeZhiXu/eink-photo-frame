// ============================================================
// Four bezels assembled together as a complete frame
// ============================================================
include <common.scad>
use <bezel_top.scad>
use <bezel_bottom.scad>
use <bezel_left.scad>
use <bezel_right.scad>

color("Silver") bezel_top();
color("Silver") bezel_bottom();
color("Silver") bezel_left();
color("Silver") bezel_right();
