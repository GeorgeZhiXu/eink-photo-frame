// ============================================================
// Front Bezel - Bottom Side (mitered 45° corners)
// Channel narrowed at bottom edge for thin 0.8mm panel rim.
// Side channels remain full width for left/right panel rims.
// ============================================================
include <common.scad>

module bezel_bottom() {
    // Bottom channel: just enough for the thin bottom panel rim
    bottom_channel = bottom_rim + 2 * channel_tol;  // ~1.2mm

    // Fill on the WINDOW side, leaving channel near the OUTER WALL
    // Channel is right behind the outer wall (where panel rim sits)
    // Fill goes from channel end to the window edge
    fill_y_start = outer_wall + bottom_channel;  // after outer wall + channel
    fill_y_end   = win_y;                        // up to window
    fill_depth   = fill_y_end - fill_y_start;

    // Leave outer_wall clear on each X side for side channels
    fill_x_start = outer_wall;
    fill_x_end   = frame_w - outer_wall;

    intersection() {
        union() {
            front_bezel_full();

            // Wall inside the channel to narrow it for the thin bottom rim
            // Only at channel depth (z=0 to frame_d), not bezel body depth
            // This leaves the space above (toward window) open for the display
            if (fill_depth > 0) {
                translate([fill_x_start, fill_y_start, 0])
                    cube([fill_x_end - fill_x_start, fill_depth, frame_d]);
            }
        }
        miter_region_bottom();
    }
}

bezel_bottom();
