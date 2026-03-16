// ============================================================
// Photo Frame for 13.3" Spectra 6 E-Ink Display
// Shared parameters and utility modules
// ============================================================

/* [Display Parameters] */
// Active (visible) area
active_w = 202.8;
active_h = 270.4;
// Glass outline dimensions
glass_w = 208.8;
glass_h = 284.7;
display_d = 0.85;
// Non-active border (asymmetric)
border_left   = 3.0;
border_right  = 3.0;
border_top    = 3.0;
border_bottom = 11.3;   // 284.7 - 270.4 - 3 = 11.3, FPC side, large non-active area

/* [Driver Board Parameters] */
board_w = 80;
board_h = 40;
board_d = 1.6;
board_clearance = 10;     // component height clearance

/* [Battery Parameters] */
battery_w = 60;
battery_h = 35;
battery_d = 8;

/* [Frame Parameters] */
bezel_w    = 13.5;        // total visible bezel width (uniform, fits largest lip)
wall_thick = 2.4;         // front frame thickness
back_thick = 1.2;         // back panel thickness (6 layers @ 0.2mm)
cavity_tol = 0.55;        // clearance above display in cavity
frame_d    = back_thick + display_d + cavity_tol;  // 2.6mm
tol        = 0.2;         // glass to cavity clearance
corner_r   = 3;

/* [Channel Parameters] */
outer_wall     = 2.0;     // outer wall thickness on bezel
inner_lip_d    = 0.3;     // inner lip depth (presses on display)
channel_tol    = 0.2;     // clearance for back panel in channel
visible_border = 1.0;     // gap between bezel inner edge and active display area

// Lip: part of bezel that overlaps and presses on display glass
lip_overlap = min(border_left, border_right, border_top) - visible_border;

/* [Printer Limits] */
bed_max = 260;

/* [Stand Parameters] */
stand_angle = 12;         // tilt angle in degrees
stand_foot_depth = 100;   // how far the base extends back

/* [FPC Cable] */
// 60-pin FPC exits from bottom of display, offset 2mm to the right
fpc_w = 134;              // FPC ribbon width
fpc_slot_w = fpc_w + 8;   // slot width with clearance (+4mm wider)
fpc_offset_x = 2;         // shifted 2mm to the right from center
fpc_slot_h = 6;

/* [Buttons - 1 reset + 3 custom] */
button_dia     = 3.5;
button_spacing = 12;
button_count   = 4;

/* [Joint Parameters] */
tongue_depth  = 1.2;      // tongue-and-groove interlock depth
tongue_length = 15;        // each tongue segment length
tongue_count  = 4;         // number of tongue segments along width
screw_r       = 1.5;       // M3 screw radius

// ============================================================
// Derived dimensions
// ============================================================

// Per-side lip (derived from borders)
// Use the largest border to set bezel_w, so all sides are uniform
lip_bottom = border_bottom - visible_border;         // 10.3mm (largest)

// Bezel layout: outer_wall + 2*channel_tol + rim + lip = bezel_w
// All sides use the same bezel_w (set to fit the largest lip)
// Side/top channel is wider (more rim), bottom channel is narrower
channel_w   = bezel_w - outer_wall - lip_overlap;    // side/top channel
panel_rim   = channel_w - 2 * channel_tol;           // side/top rim

channel_w_bot = bezel_w - outer_wall - lip_bottom;   // bottom channel
bottom_rim    = channel_w_bot - 2 * channel_tol;     // bottom rim

inner_lip_w = lip_overlap;    // side/top lip width (2.0mm)

// Frame and cavity dimensions (uniform bezel_w on all sides)
cavity_w = glass_w + 2 * tol;
cavity_h = glass_h + 2 * tol;
frame_w  = glass_w - 2 * lip_overlap + 2 * bezel_w;
frame_h  = glass_h - lip_overlap - lip_bottom + 2 * bezel_w;

// Derived panel dimensions
panel_w = cavity_w + 2 * panel_rim;
panel_h = cavity_h + panel_rim + bottom_rim;
panel_inset = (frame_w - panel_w) / 2;

// Back panel split: bottom piece as tall as fits the bed
back_split_y = bed_max - 10;   // 250mm from bottom, top piece ~60mm

// Base dimensions (foot/stand only, attaches to bottom of back panel)
base_wall = wall_thick;
base_total_depth = stand_foot_depth;

// ============================================================
// Utility modules
// ============================================================

module rounded_rect(w, h, d, r) {
    linear_extrude(d)
        offset(r = r)
            offset(r = -r)
                square([w, h]);
}

module rounded_rect_2d(w, h, r) {
    offset(r = r)
        offset(r = -r)
            square([w, h]);
}

// Tongue segments along X axis at a given Y position
module tongue_strip(width, y_pos, z_pos, depth, length, count) {
    spacing = width / (count + 1);
    for (i = [1 : count]) {
        translate([i * spacing - length / 2, y_pos, z_pos])
            cube([length, depth, back_thick]);
    }
}

// ============================================================
// Front bezel - mitered picture frame style (4 sides)
// ============================================================

// Window position and size (bezel_w is uniform on all sides)
win_x = bezel_w;
win_y = bezel_w;
win_w = glass_w - 2 * lip_overlap;
win_h = glass_h - lip_overlap - lip_bottom;

// Bezel Z layout:
//   z=0                           bottom of outer wall (back of frame)
//   z=frame_d                     bezel body bottom (= back panel top)
//   z=frame_d+wall_thick          bezel front face

module front_bezel_full() {
    union() {
        // 1. Bezel body (visible frame, sits on top of back panel)
        difference() {
            translate([0, 0, frame_d])
                rounded_rect(frame_w, frame_h, wall_thick, corner_r);

            // Window opening - sharp corners (display glass is rectangular)
            translate([win_x, win_y, -0.1])
                cube([win_w, win_h, frame_d + wall_thick + 0.2]);
        }

        // 2. Outer wall (wraps around back panel edge)
        difference() {
            rounded_rect(frame_w, frame_h, frame_d + wall_thick, corner_r);

            // Hollow inside - sharp corners
            translate([outer_wall, outer_wall, -0.1])
                cube([
                    frame_w - 2 * outer_wall,
                    frame_h - 2 * outer_wall,
                    frame_d + wall_thick + 0.2
                ]);
        }

        // 3. Inner lip (presses on display glass)
        difference() {
            translate([win_x - inner_lip_w, win_y - inner_lip_w, frame_d - inner_lip_d])
                cube([win_w + 2 * inner_lip_w, win_h + 2 * inner_lip_w, inner_lip_d]);

            translate([win_x, win_y, frame_d - inner_lip_d - 0.1])
                cube([win_w, win_h, inner_lip_d + 0.2]);
        }
    }
}

// 45-degree miter cutting regions for each side
// Each region is a 2D polygon extruded tall enough to cut the bezel
e = 1; // margin for clean cuts

// Bottom: below both 45° lines from bottom corners
module miter_region_bottom() {
    linear_extrude(50, center = true)
        polygon([[-e, -e], [frame_w + e, -e], [frame_w / 2, frame_w / 2]]);
}

// Top: above both 45° lines from top corners
module miter_region_top() {
    linear_extrude(50, center = true)
        polygon([[-e, frame_h + e], [frame_w + e, frame_h + e],
                 [frame_w / 2, frame_h - frame_w / 2]]);
}

// Left: between 45° lines from both left corners
module miter_region_left() {
    linear_extrude(50, center = true)
        polygon([[-e, -e], [frame_h / 2, frame_h / 2], [-e, frame_h + e]]);
}

// Right: between 45° lines from both right corners
module miter_region_right() {
    linear_extrude(50, center = true)
        polygon([[frame_w + e, -e],
                 [frame_w - frame_h / 2, frame_h / 2],
                 [frame_w + e, frame_h + e]]);
}

// Full back panel (smaller than bezel, fits inside channel)
module back_panel_full() {
    // FPC slot X position: centered + offset to the right
    fpc_x = (panel_w - fpc_slot_w) / 2 + fpc_offset_x;

    difference() {
        rounded_rect(panel_w, panel_h, frame_d, max(corner_r - panel_inset, 0.5));

        // Display cavity
        translate([panel_rim, bottom_rim, back_thick])
            cube([cavity_w, cavity_h, frame_d]);

        // FPC cable exit slot at bottom (offset 2mm to right)
        translate([fpc_x, -0.1, back_thick])
            cube([fpc_slot_w, bottom_rim + 0.1, frame_d - back_thick + 0.1]);

        // FPC ribbon gap: 4mm zone from panel bottom edge
        // Goes through the full back wall so ribbon can fold freely
        fpc_gap = 4;
        translate([fpc_x, 0, -0.1])
            cube([fpc_slot_w, fpc_gap, frame_d + 0.1]);
    }
}
