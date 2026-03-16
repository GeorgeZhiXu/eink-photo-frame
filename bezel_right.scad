// ============================================================
// Front Bezel - Right Side (mitered 45° corners)
// ============================================================
include <common.scad>

module bezel_right() {
    intersection() {
        front_bezel_full();
        miter_region_right();
    }
}

bezel_right();
