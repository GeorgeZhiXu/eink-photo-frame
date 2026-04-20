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
board_w = 80.2;           // measured
board_h = 41.2;           // measured
board_d = 1.6;
board_clearance = 10;     // component height clearance
// Hole positions
board_hole_dia = 2.4;
board_hole_edge_x = 2.4;                 // measured: actual hole center to board edge
board_hole_edge_y = 2.4;                 // measured: actual hole center to board edge
board_hole_h = 75;        // horizontal hole spacing
board_hole_v = 36;        // vertical hole spacing
// Board X offset: left edge is 1mm left of display left edge
board_offset_x = 1.0;
// Protrusions from board edge (buttons/USB-C/switch on back edge)
usb_c_protrusion = 1.5;   // USB-C sticks out from board edge
button_protrusion = 1.0;   // buttons stick out from board edge

/* [Battery Parameters] */
battery_w = 72;
battery_h = 40;
battery_d = 20;           // updated: actual battery is thicker than expected
batterh_wire_d = 1.6;

/* [Frame Parameters] */
bezel_w    = 13.5;        // total visible bezel width (uniform, fits largest lip)
wall_thick = 1.2;         // front frame thickness
back_thick = 1.2;         // back panel thickness (6 layers @ 0.2mm)
cavity_tol = 0.85;        // clearance above display in cavity
frame_d    = back_thick + display_d + cavity_tol;  // 2.6mm
xy_tol     = 0.4;         // use line width as tol in xy direction
z_tol      = 0.2;         // use line height as tol in z direction
tol        = 0.2;         // glass to cavity clearance
corner_r   = 3;

/* [Channel Parameters] */
outer_wall     = 2.0;     // outer wall thickness on bezel
inner_lip_d    = 0.6;     // inner lip depth (presses on display)
channel_tol    = 0.2;     // clearance for back panel in channel
visible_border = 1.0;     // gap between bezel inner edge and active display area

// Lip: part of bezel that overlaps and presses on display glass
lip_overlap = min(border_left, border_right, border_top) - visible_border;

/* [Printer Limits] */
bed_max = 260;

/* [Stand Parameters] */
stand_angle = 12;         // tilt angle in degrees
stand_foot_depth = 64.6;  // board edge + 0.2mm clearance to back wall interior

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
lip_bottom = lip_overlap;  // same as sides (bottom hidden by base, no need for large lip)

// Bezel layout: outer_wall + 2*channel_tol + rim + lip = bezel_w
// All sides use the same bezel_w (set to fit the largest lip)
// Side/top channel is wider (more rim), bottom channel is narrower
channel_w   = bezel_w - outer_wall - lip_overlap;    // side/top channel
panel_rim   = channel_w - 2 * channel_tol;           // side/top rim

bottom_rim    = panel_rim;  // same as other sides (thin rim was fragile)

// Frame and cavity dimensions (uniform bezel_w on all sides)
cavity_w = glass_w + 2 * xy_tol;
cavity_h = glass_h + 2 * xy_tol;
frame_w  = glass_w - 2 * lip_overlap + 2 * bezel_w;
frame_h  = glass_h - lip_overlap - lip_bottom + 2 * bezel_w;

// Derived panel dimensions
panel_w = cavity_w + 2 * panel_rim;
panel_h = cavity_h + panel_rim + bottom_rim;
panel_inset = (frame_w - panel_w) / 2;

// Back panel split: bottom piece as tall as fits the bed
back_split_y = bed_max - 20;   // 240mm from bottom, top piece ~50mm

// Base dimensions (foot/stand only, attaches to bottom of back panel)
base_wall = outer_wall;   // match bezel outer wall so they fuse at front
base_total_depth = stand_foot_depth;

$fn = 180;

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
//
// Subtractive approach: start with solid frame, carve out:
//   1. Window opening (through the bezel face)
//   2. Channels (per-side, for back panel rims to snap in)
//   3. Lip recess (cavity for display glass, leaving 0.3mm lip)
//   4. Miter cut (45° to isolate one side)
// ============================================================

// Window position and size (bezel_w is uniform on all sides)
win_x = bezel_w;
win_y = bezel_w;
win_w = glass_w - 2 * lip_overlap;
win_h = glass_h - lip_overlap - lip_bottom;

// Per-side lip and channel widths
function lip_for(side) =
    (side == "bottom") ? lip_bottom : lip_overlap;

function channel_for(side) =
    bezel_w - outer_wall - lip_for(side);

// ============================================================
// bezel_side(side) - builds one mitered bezel piece
//
// Cross-section per side (outer edge inward):
//   outer_wall (2mm) | channel (rim + tol) | lip (on display)
// ============================================================

module bezel_side(side) {
    ch_l = channel_for("left");
    ch_r = channel_for("right");
    ch_t = channel_for("top");
    ch_b = channel_for("bottom");

    intersection() {
        difference() {
            // Solid frame: outer wall full height, bezel face on top
            union() {
                rounded_rect(frame_w, frame_h, frame_d, corner_r, $fn = 180);
                translate([0, 0, frame_d])
                    rounded_rect(frame_w, frame_h, wall_thick, corner_r, $fn = 180);
            }

            // 1. Window opening
            translate([win_x, win_y, 0])
                cube([win_w, win_h, frame_d + wall_thick]);

            // 2. Channels: carve per-side channel slots (full frame_d depth)
            translate([outer_wall, outer_wall, 0])
                cube([frame_w - 2 * outer_wall, ch_b, frame_d]);
            translate([outer_wall, frame_h - outer_wall - ch_t, 0])
                cube([frame_w - 2 * outer_wall, ch_t, frame_d]);
            translate([outer_wall, outer_wall, 0])
                cube([ch_l, frame_h - 2 * outer_wall, frame_d]);
            translate([frame_w - outer_wall - ch_r, outer_wall, 0])
                cube([ch_r, frame_h - 2 * outer_wall, frame_d]);

            // 3. Lip recess: cavity under the lip zone, leaving inner_lip_d
            translate([outer_wall + ch_l, outer_wall + ch_b, 0])
                cube([
                    frame_w - 2 * outer_wall - ch_l - ch_r,
                    frame_h - 2 * outer_wall - ch_b - ch_t,
                    frame_d - inner_lip_d
                ]);
        }

        // 4. Miter cut
        _miter_region(side);
    }
}



module _miter_region(side) {
    // 45-degree miter cutting regions
    e = 1;
    if (side == "bottom")
        linear_extrude(50, center = true)
            polygon([[-e, -e], [frame_w + e, -e], [frame_w / 2, frame_w / 2]]);
    else if (side == "top")
        linear_extrude(50, center = true)
            polygon([[-e, frame_h + e], [frame_w + e, frame_h + e],
                     [frame_w / 2, frame_h - frame_w / 2]]);
    else if (side == "left")
        linear_extrude(50, center = true)
            polygon([[-e, -e], [frame_h / 2, frame_h / 2], [-e, frame_h + e]]);
    else // right
        linear_extrude(50, center = true)
            polygon([[frame_w + e, -e],
                     [frame_w - frame_h / 2, frame_h / 2],
                     [frame_w + e, frame_h + e]]);
}

// Full back panel (smaller than bezel, fits inside channel)
module back_panel_full() {
    fpc_x = (panel_w - fpc_slot_w) / 2 + fpc_offset_x;
    echo(fpc_x);
    e = 0.01;  // epsilon for clean boolean cuts through boundary faces

    // FPC tunnel: thin horizontal slot through rim and back wall
    // Visible as a narrow slit on the back face and cavity side
    // Prints without support (back face down, tunnel ceiling bridges 7.6mm)
    fpc_window_h = 3.0;  // FPC ribbon ~0.3mm + clearance
    fpc_window_z = back_thick;  // tunnel sits right on top of back wall

    difference() {
        rounded_rect(panel_w, panel_h, frame_d, max(corner_r - panel_inset, 0.5), $fn = 180);

        // Display cavity (cuts through top face at z=frame_d)
        translate([panel_rim, bottom_rim, back_thick])
            cube([cavity_w, cavity_h, frame_d - back_thick + e]);

        // Single tunnel from outside (y=-e) through rim into cavity (+2mm)
        translate([fpc_x, bottom_rim, -e]) {
            rotate([0, 90, 0])
                cylinder(fpc_slot_w, fpc_window_h / 2, fpc_window_h / 2, false, $fn = 180);
            cube([fpc_slot_w, fpc_window_h / 2, fpc_window_h / 2]);
        }   
    }
}

