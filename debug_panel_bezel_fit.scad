// ============================================================
// Debug: Panel rim fitting into bottom bezel channel
//
// Shows a 2D cross-section at X = frame_w/2, zoomed to the
// bottom 20mm where the back panel rim sits in the bezel channel.
//
// You should see two pieces side by side:
//   Left:  back panel rim (thin, frame_d tall)
//   Right: bottom bezel (outer wall + channel gap + lip)
//
// The gap between them is channel_tol (0.2mm) on each side.
// ============================================================
include <common.scad>
use <bezel_bottom.scad>
use <back_panel_bottom.scad>

linear_extrude(0.1)
projection(cut = true)
    rotate([0, 90, 0])
        translate([-frame_w / 2, 0, 0])
        intersection() {
            union() {
                // Bottom bezel (frame coordinates)
                bezel_bottom();
                // Back panel (offset into frame coordinates)
                translate([panel_inset, panel_inset, 0])
                    back_panel_bottom();
            }
            // Clip to bottom 20mm to zoom in on the rim/channel area
            translate([-1, -1, -1])
                cube([frame_w + 2, 20, 20]);
        }
