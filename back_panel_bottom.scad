// ============================================================
// Back Panel - Bottom (large piece, ~250mm tall, includes FPC slot)
// ============================================================
include <common.scad>

module back_panel_bottom() {
    difference() {
        back_panel_full();
        // Cut away top portion
        translate([-1, back_split_y, -1])
            cube([panel_w + 2, panel_h + 2, frame_d + 2]);
        // Groove slots to receive tongues from top piece
        // Cut through full back wall depth (back_thick + margin)
        groove_y = back_split_y - tongue_depth - tol;
        groove_depth = tongue_depth + 2 * tol;
        groove_len = tongue_length + 2 * tol;
        groove_spacing = panel_w / (tongue_count + 1);
        for (i = [1 : tongue_count]) {
            translate([i * groove_spacing - groove_len / 2, groove_y, -0.1])
                cube([groove_len, groove_depth, back_thick + 0.2]);
        }
    }
}

back_panel_bottom();
