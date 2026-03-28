// ============================================================
// 3D Printable Screws / Fasteners for board mounting
//
// Two designs:
//   1. Friction-fit bolt: simple shaft + head
//   2. Snap-fit pin: shaft with barbs that grip the standoff hole
//
// Print upside down (head on bed) for best quality.
// Print several extras - small parts are fragile.
// ============================================================

// Board and standoff specs (from common.scad)
hole_dia     = 2.4;    // board hole and standoff hole diameter
standoff_h   = 6.2;    // standoff height
board_d      = 1.6;    // board thickness

// ---------- Design 1: Friction-fit bolt ----------
module friction_bolt() {
    shaft_d  = 2.3;    // tight fit in 2.4mm hole
    head_d   = 5.0;    // holds board down
    head_h   = 1.5;    // head thickness
    shaft_h  = standoff_h + board_d;  // through board + full standoff depth

    // Head (flat cylinder)
    cylinder(d = head_d, h = head_h, $fn = 180);

    // Shaft
    translate([0, 0, head_h])
        cylinder(d = shaft_d, h = shaft_h, $fn = 180);

    // Slight taper at tip for easier insertion
    translate([0, 0, head_h + shaft_h - 0.5])
        cylinder(d1 = shaft_d, d2 = shaft_d - 0.4, h = 0.5, $fn = 180);
}

// ---------- Design 2: Snap-fit pin with barbs ----------
module snap_pin() {
    shaft_d    = 2.0;   // thinner shaft for flex
    head_d     = 5.0;   // holds board down
    head_h     = 1.5;
    shaft_h    = standoff_h + board_d;
    barb_d     = 2.6;   // wider than hole for snap grip
    barb_h     = 1.0;   // barb height
    barb_pos   = head_h + board_d + 1;  // barb below board level

    // Head
    cylinder(d = head_d, h = head_h, $fn = 180);

    // Shaft
    translate([0, 0, head_h])
        cylinder(d = shaft_d, h = shaft_h, $fn = 180);

    // Barbs (2 opposing bumps that snap past the standoff hole edge)
    for (angle = [0, 180]) {
        rotate([0, 0, angle])
            translate([0, 0, barb_pos])
                resize([barb_d, shaft_d, barb_h])
                    sphere(d = barb_d, $fn = 180);
    }

    // Taper at tip
    translate([0, 0, head_h + shaft_h - 0.8])
        cylinder(d1 = shaft_d, d2 = shaft_d - 0.6, h = 0.8, $fn = 180);
}

// ---------- Layout: print 8 of each (4 needed + spares) ----------
spacing = 8;

// Row 1: Friction bolts
for (i = [0 : 7]) {
    translate([i * spacing, 0, 0])
        friction_bolt();
}

// Row 2: Snap pins
for (i = [0 : 7]) {
    translate([i * spacing, spacing * 2, 0])
        snap_pin();
}
