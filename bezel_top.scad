// ============================================================
// Front Bezel - Top Side (mitered 45° corners)
// ============================================================
include <common.scad>

module bezel_top() {
    intersection() {
        front_bezel_full();
        miter_region_top();
    }
}

bezel_top();
