// ============================================================
// Full Assembly - all parts in desk position
//
// Desk coordinates: X=width, Y=depth (front to back), Z=height
// Panel leans back at stand_angle (12°) from vertical
//
// Bezel parts are built flat in XY with Z=thickness:
//   z=0 is the back (panel side), z=max is the front (viewer side)
//   y=0 is the bottom edge of the frame
//
// To assemble: rotate so the bezel face points toward -Y (viewer),
// frame stands up in Z, and leans back by stand_angle.
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

// Base sits flat on desk at origin
color("DimGray")
    base_stand();

// Tilted frame assembly
// In bezel coords: X=width, Y=height(bottom=0), Z=depth(back=0, front=max)
// Step 1: rotate -90° around X to stand up (Y -> Z, Z -> -Y)
// Step 2: rotate stand_angle around X to lean back
// Step 3: translate to sit on base shelf
//
// After rotation, the bottom-front corner of the bezel (x=0, y=0, z=frame_d+wall_thick)
// maps to desk position. We need this to sit at the base front edge on the desk.

// The frame bottom-front edge after rotation lands at:
//   y = (frame_d + wall_thick) * cos(stand_angle)
//   z = -(frame_d + wall_thick) * sin(stand_angle)
// We want z=0 (on desk), so translate up by the z offset.

_total_d = frame_d + wall_thick;

// Rotation: first stand up (-90° around X), then lean back (stand_angle)
// After -90° rotation: bezel y=0 (bottom) goes to z=0 (desk), z (depth) goes to -y
// After lean: tilt stand_angle backward around X
// Translation: adjust so bottom-back corner sits at desk level (z=0)
translate([0, 0, 0])
    rotate([-stand_angle, 0, 0])
    rotate([90, 0, 0])
    {
        // Four bezels
        color("Silver") bezel_top();
        color("Silver") bezel_bottom();
        color("LightSlateGray") bezel_left();
        color("LightSlateGray") bezel_right();

        // Back panels
        color("SlateGray")
            translate([panel_inset, panel_inset, 0]) {
                back_panel_bottom();
                back_panel_top();
            }

        // Display glass (ghost)
        %translate([panel_inset + panel_rim, panel_inset + bottom_rim, back_thick])
            color("LightBlue", 0.5)
                cube([glass_w, glass_h, display_d]);
    }
