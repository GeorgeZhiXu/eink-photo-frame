// ============================================================
// Back Panel - Top (small piece, ~60mm tall)
// ============================================================
include <common.scad>

module back_panel_top() {
    difference() {
        back_panel_full();
        // Cut away bottom portion
        translate([-1, -1, -1])
            cube([panel_w + 2, back_split_y + 1, frame_d + 2]);
    }
    // Tongue tabs extending below the cut edge
    tongue_strip(panel_w, back_split_y - tongue_depth, 0, tongue_depth, tongue_length, tongue_count);
}

back_panel_top();
