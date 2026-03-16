// ============================================================
// Front Bezel - Left Side (mitered 45° corners)
// ============================================================
include <common.scad>

module bezel_left() {
    intersection() {
        front_bezel_full();
        miter_region_left();
    }
}

bezel_left();
