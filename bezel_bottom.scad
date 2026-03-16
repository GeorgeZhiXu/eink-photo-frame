// ============================================================
// Front Bezel - Bottom Side (mitered 45° corners)
// Bottom has large lip (10.3mm) over the display's 11.3mm
// inactive area, with narrow channel (1.2mm) for thin rim.
// Side channels at corners remain open for left/right rims.
// ============================================================
include <common.scad>

module bezel_bottom() {
    bezel_side("bottom");
}

bezel_bottom();
