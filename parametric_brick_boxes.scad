// =====================================================================
//  Parametric brick boxes
// =====================================================================
//
//  A printable storage box, studded all over, made for building on with
//  real LEGO.
//    - every dimension is LEGO units: footprints in studs (8 mm pitch,
//      0.1 mm play per side), heights in stud rows (8 mm)
//    - each face - top, bottom, front, back, left, right - is studs,
//      sockets (holes that take studs) or flat, edge to edge. The walls
//      run from the bed up to the seam and round the lid band (not the back
//      of its bottom row, which lands on the wall top at 90 deg)
//    - a flat, hollow lid, so plates press onto its top studs and pry off
//      easily
//    - an optional text label on the lid top, engraved or raised, with the
//      top studs round it left out
//    - lid (the top band) over an open storage box, hinged on two tabs at
//      the back (friction pins, holds any angle up to 90 deg, lifts off at
//      90 deg)
//
//  Box height is set in side stud rows: side_rows, counting the lid band's
//  lid_rows, plus rise for each shelf row back (see row). Every box is whole
//  stud rows tall, so the side studs of neighbouring boxes line up.
//
//  Box size is studs_l x studs_w, the whole footprint.
//
//  Printing:
//    body  upright as modelled (open top up). Bottom studs land on the bed
//          and need supports; with bottom sockets or flat, no supports
//    lid   inverted: top down, open underside up. Top studs land on the bed
//          and need supports; with top sockets or flat, no supports (a
//          raised label needs them too; an engraved one doesn't).
//          Everything else - the 45 deg groove edge, hinge slots, detent
//          pocket - opens upwards
//  Hinge: the body's tabs print upright with flat-bottomed pins. To fit the
//  lid, hold it upright (open 90 deg) behind the tabs and slide it forward
//  onto the pins, then close it. Tune hinge_play for stiffness.
//  Side studs print as short horizontal pegs, with a small flat shaved off
//  the side facing down as printed (side_stud_flat) so the worst of the
//  overhang is gone. Side sockets are teardrops, pointed up as printed.
//  Print stud_fit_test.scad, then a 6 x 5 box, to tune stud_d / side_stud_d /
//  socket_d / side_socket_d / lid_clear.
//  Set row for where the box stands on the shelf, then export with part = print / body / lid.
// =====================================================================

/* [Box to print] */
part = "print";         // [print, body, lid, assembled]
// open the lid in previews, degrees
lid_open = 0;           // [0:5:90]

/* [Box size] */
// box length, left to right, studs (the whole footprint)
studs_l = 21;           // [4:1:40]
// box width, front to back, studs
studs_w = 12;           // [4:1:30]
// stud rows on the sides of a front-row box, the lid band's included - sets the box height
side_rows = 2;          // [2:1:30]
// stud rows on the lid band, out of side_rows (the body keeps at least one)
lid_rows = 1;           // [1:1:10]
// extra stud rows for each row further back
rise = 6;               // [0:1:12]
// shelf row the box is for, 0 = front: each row back is rise stud rows taller, so whatever stands on the boxes in back sits higher
row = 0;                // [0:1:6]
// rounding of the vertical edges, mm (the corner studs start 1.5 mm in)
corner_r = 1;           // [0:0.25:1.5]

/* [Studs] */
// each face, edge to edge: studs, sockets (holes that take studs) or flat
top = "studs";          // [studs, sockets, flat]
bottom = "studs";       // [studs, sockets, flat]
front = "studs";        // [studs, sockets, flat]
back = "studs";         // [studs, sockets, flat]
left = "studs";         // [studs, sockets, flat]
right = "studs";        // [studs, sockets, flat]
// printed stud diameter - tune for clutch (LEGO 4.8)
stud_d = 4.85;          // [4.6:0.05:5.1]
stud_h = 1.8;           // [1.2:0.1:2]
// wall studs print sideways and size differently - tune separately
side_stud_d = 4.85;     // [4.6:0.05:5.1]
// flat shaved off the underside of wall studs, for a cleaner overhang
side_stud_flat = 0.4;   // [0:0.1:1]
// socket diameter in the top and bottom - tune for clutch on the studs you'll press in
socket_d = 4.9;         // [4.6:0.05:5.3]
// wall sockets print sideways and size differently - tune separately
side_socket_d = 4.9;    // [4.6:0.05:5.3]

/* [Box construction] */
// wall thickness, mm (under 3.2 the lid's seat ridge and the skin over the detent get thin)
wall = 3.2;             // [2.4:0.4:6]
// floor thickness (3.2 = 1 plate; at least 3.2 under bottom sockets)
floor_t = 3.2;          // [1.6:0.8:6.4]
// play between the lid groove and the wall ridge
lid_clear = 0.2;        // [0:0.05:0.6]
// lid top skin thickness: under it the lid is hollow, inside the outer lip (at least 3.2 under top sockets)
lid_top = 1.6;          // [1.2:0.4:4]

/* [Lid hinge] */
// studs from each end of the box to a hinge tab
hinge_from_end = 1;     // [1:1:6]
// pins on the tabs
hinge_pin_d = 3;        // [2.4:0.1:3.4]
// pin hole minus pin diameter - smaller = stiffer, so the lid holds its angle
hinge_play = 0.05;      // [-0.1:0.05:0.4]
// gap around the tabs in their slots
hinge_clear = 0.25;     // [0.1:0.05:0.5]

/* [Lid detent] */
// snap detents on the front wall top - squeeze the box front there to open: 1 = centred, 2 = a quarter in from each end (0 = off)
detent_count = 1;       // [0:1:2]
// detent length along the front, studs
detent_len = 2;         // [1:1:6]
// how far the front wall has to bow in to let the lid go - more = firmer snap, harder squeeze
detent_bump = 0.3;      // [0.1:0.05:0.6]

/* [Lid label] */
// text on the lid top, reading from the front; empty for none
label = "";
// text height, mm
label_size = 8;         // [3:0.5:30]
label_font = "Liberation Sans:style=Bold";
// engraved into the top skin (no supports), or raised off it
label_style = "engraved";   // [engraved, raised]
// how deep it is engraved, or how far it stands up, mm; 0 leaves just the stud-free space
label_depth = 0.6;      // [0:0.1:1.6]

/* [Printing] */
bed_x = 250;
bed_y = 250;
bed_z = 250;

/* [Hidden] */
PITCH = 8;              // stud pitch, and the height of a side stud row
PLATE = 3.2;            // plate height (brick = 3 plates)
PLAY = 0.1;             // LEGO play per side: n studs = n * 8 - 0.2 mm
LID_ROWS = max(1, round(lid_rows));
LID_H = LID_ROWS * PITCH;   // lid band: lid_rows rows of side studs
WALL = wall;
RIM = 1.2;              // flat lid rim on the wall top, outside the seat
TIP = 0.8;              // flat on the inner edge of the seat ridge
SEAT = max(0.4, WALL - RIM - TIP);   // height of the 45 deg seat ridge above the seam
HR = PITCH / 2;         // hinge axis: HR above the seam (mid-height of the lid band's bottom row), HR in from the back face
TAB_R = 2;              // hinge tab head radius
TAB_W = 6;              // tab thickness along the axis
TAB_D = 6;              // tab stem depth in front of the axis: a solid block, buttressed down the inside of the back wall
PIN_L = 1.5;            // pin length out of each tab face
PIN_FLAT = 0.5;         // flat on top and bottom of each pin: prints clean, and only passes the lead-in at 90 deg
DT_U = min(2, WALL - 1.2);   // detent post: its outer face, in from the front face (the lid skin outside it)
DT_V = 2.2;             // ... and the height of that vertical face above the seam
DT_Z = 1.4;             // detent bead centre above the seam, on the post's outer face
DT_FLAT = 0.6;          // flat on the bead tip
BEEF = 2;               // lid: solid margin round the hinge slots and the detent pocket
SOCKET_H = stud_h + 0.2;   // socket depth: a stud seats fully
SOCKET_CH = 0.4;        // 45 deg chamfer on the socket mouth: lead-in, and room for first-layer squish
SOCKET_MIN = SOCKET_H + 1.2;   // material a socket needs: its depth and a skin behind it
SIDES = [front, back, left, right];
FLOOR = bottom == "sockets" ? max(floor_t, SOCKET_MIN) : floor_t;
LID_TOP = top == "sockets" ? max(lid_top, SOCKET_MIN) : lid_top;
eps = 0.01;
$fn = 40;

function mm(n) = n * PITCH - 2 * PLAY;

// ---------------------------------------------------------------------
//  Size
// ---------------------------------------------------------------------
FS = [max(4, round(studs_l)), max(4, round(studs_w))];   // footprint, studs
ROWS = max(LID_ROWS + 1, round(side_rows)) + row * rise;   // side stud rows, the lid band's included
BH = ROWS * PITCH;                                         // box height, mm

// ---------------------------------------------------------------------
//  Lid label: text centred on the top, with every top stud or socket
//  that would come within LABEL_GAP of the text's outline left out
// ---------------------------------------------------------------------
LABEL = label != "";
RAISED = label_style == "raised";
LABEL_D = RAISED ? label_depth : min(label_depth, LID_TOP - 0.4);   // engraved: keep 0.4 mm of skin under it
TOP_TIP = max(top == "studs" ? stud_h : 0, LABEL && RAISED ? LABEL_D : 0);   // how far anything stands up off the lid top
LABEL_GAP = 1;          // clear space round the text
// the text's bounding box, [[x0, y0], [x1, y1]]. OpenSCAD without textmetrics() gets an estimate
LABEL_TM = LABEL ? textmetrics(text = label, size = label_size, font = label_font, halign = "center", valign = "center") : undef;
LABEL_BOX = is_undef(LABEL_TM) ? let(w = len(label) * label_size * 0.7) [[-w / 2, -label_size / 2], [w / 2, label_size / 2]]
                               : [LABEL_TM.position, LABEL_TM.position + LABEL_TM.size];
function in_label(fs, x, y) = let(r = (top == "sockets" ? socket_d / 2 + SOCKET_CH : stud_d / 2) + LABEL_GAP)
    LABEL && x > LABEL_BOX[0][0] - r && x < LABEL_BOX[1][0] + r && y > LABEL_BOX[0][1] - r && y < LABEL_BOX[1][1] + r;
module label2d(fs) text(label, size = label_size, font = label_font, halign = "center", valign = "center");

// ---------------------------------------------------------------------
//  Studs
// ---------------------------------------------------------------------
function cols(n) = [for (i = [0:n - 1]) (i - (n - 1) / 2) * PITCH];

// side stud centres on a face w wide, h high, relative to its centre: [[x, z], ...]
function face_pts(w, h) = let(nx = round(w / PITCH), nz = round(h / PITCH))
    [for (i = [0:nx - 1], k = [0:nz - 1]) [(i - (nx - 1) / 2) * PITCH, (k - (nz - 1) / 2) * PITCH]];

// stud with a 0.3 mm chamfer on the tip, so plates find it and press on easily
module stud_shape(d) {
    cylinder(d = d, h = stud_h - 0.3 + eps, $fn = 48);
    translate([0, 0, stud_h - 0.3]) cylinder(d1 = d, d2 = d - 0.6, h = 0.3, $fn = 48);
}
module stud() stud_shape(stud_d);
// wall stud: local -y ends up pointing down, so that is where the flat goes
// (or +y, up, for the lid, which prints inverted)
module side_stud(lid = false) intersection() {
    stud_shape(side_stud_d);
    mirror([0, lid ? 1 : 0, 0])
        translate([-side_stud_d, -side_stud_d / 2 + side_stud_flat, -1]) cube([2 * side_stud_d, 2 * side_stud_d, stud_h + 2]);
}

// socket cutters, going +z into the face from z = 0, with a chamfered mouth.
// Top and bottom: round, the roof a short bridge
module socket() {
    translate([0, 0, -1]) cylinder(d = socket_d, h = SOCKET_H + 1, $fn = 48);
    translate([0, 0, -1]) cylinder(d = socket_d + 2 * SOCKET_CH, h = 1 + eps, $fn = 48);
    cylinder(d1 = socket_d + 2 * SOCKET_CH, d2 = socket_d, h = SOCKET_CH, $fn = 48);
}
// walls: a teardrop pointing up as printed, so the hole has no overhang,
// its tip flattened 0.2 mm past the circle (a short bridge) so it stays
// clear of the lid's groove. Local +y ends up pointing down (up for the lid,
// which prints inverted)
module teardrop(d) intersection() {
    hull() { circle(d = d, $fn = 48); polygon([[-eps, d / sqrt(2)], [eps, d / sqrt(2)], [0, 0]]); }
    translate([-d, -d]) square([2 * d, 1.5 * d + 0.2]);
}
module side_socket(lid = false) mirror([0, lid ? 0 : 1, 0]) {
    translate([0, 0, -1]) linear_extrude(SOCKET_H + 1) teardrop(side_socket_d);
    hull() {
        translate([0, 0, -1]) linear_extrude(1 + eps) teardrop(side_socket_d + 2 * SOCKET_CH);
        translate([0, 0, SOCKET_CH]) linear_extrude(eps) teardrop(side_socket_d);
    }
}

// one stud grid over each whole side, body and lid band together: studs
// standing straight off the wall, or sockets going into it - whichever kind
// the face is set to. Each part takes the positions between z0 and z1 (the
// back only above back_z0); any that would straddle the seam are left out.
module side_faces(fs, H, z0, z1, kind, back_z0 = -1, lid = false) {
    L = mm(fs[0]); W = mm(fs[1]);
    r = kind == "studs" ? side_stud_d / 2 : side_socket_d / 2 + SOCKET_CH;
    dl = detent_len * PITCH + 0.6;
    faces = [[front, 0, W / 2, fs[0], z0], [back, 180, W / 2, fs[0], max(z0, back_z0)],
             [right, 90, L / 2, fs[1], z0], [left, -90, L / 2, fs[1], z0]];
    for (f = faces) if (f[0] == kind) rotate(f[1]) translate([0, -f[2], 0])
        for (q = face_pts(f[3] * PITCH, H))
            let(z = H / 2 + q[1],
                // lid sockets keep clear of the detent pockets behind the front's bottom row
                clash = kind == "sockets" && lid && f[1] == 0 && z < z0 + PITCH
                        && len([for (x = detent_xs(fs)) if (abs(q[0] - x) < dl / 2 + r) x]) > 0)
            if (z - r > f[4] && z + r < z1 && !clash) {
                if (kind == "studs") translate([q[0], eps, z]) rotate([90, 0, 0]) side_stud(lid);
                else translate([q[0], 0, z]) rotate([-90, 0, 0]) side_socket(lid);
            }
}

// ---------------------------------------------------------------------
//  Box: body + lid, split lid_rows stud rows below the top
// ---------------------------------------------------------------------
module plan(fs, ins = 0) let(r = max(corner_r - ins, 0.5))
    offset(r = r) square([mm(fs[0]) - 2 * ins - 2 * r, mm(fs[1]) - 2 * ins - 2 * r], center = true);

module slab(fs, z, ins) translate([0, 0, z]) linear_extrude(eps) plan(fs, ins);

// 45 deg seat ridge on the wall tops: from inset a at height z up and in by h
module ridge(fs, z, a, h) hull() { slab(fs, z, a); slab(fs, z + h, a + h); }

// keep only what lies in front of y (box coordinates)
module front_of(fs, y) intersection() {
    children();
    translate([-mm(fs[0]), -mm(fs[1]), -1]) cube([2 * mm(fs[0]), mm(fs[1]) + y, 2 * bed_z]);
}

// ---------------------------------------------------------------------
//  Hinge: two tabs on the back wall, pinned into slots in the lid.
//  The axis runs along x HR above the seam, HR in from the back
//  face. The lid's lower back edge is rounded about it, so as the lid opens
//  nothing behind the axis ever drops below the seam, and everything in
//  front of it rises. At 90 deg the lid's back face lands on the wall top:
//  that is the stop. Hinge coordinates: u = towards the back, v = up.
// ---------------------------------------------------------------------
function hinge_axis(fs, H) = [mm(fs[1]) / 2 - HR, H - LID_H + HR];   // [y, z]
function tab_xs(fs) = [for (s = [-1, 1]) s * (mm(fs[0]) / 2 - hinge_from_end * PITCH)];

// a 2D (u, v) profile around the hinge axis, extruded along x from x0 to x1
module along_axis(fs, H, x0, x1) let(a = hinge_axis(fs, H))
    translate([x0, a[0], a[1]]) rotate([90, 0, 90]) linear_extrude(x1 - x0) children();

// tab head: teardrop so it prints upright. The stem stays in front of the axis
// (anything behind it and above the seam would swing up into the lid), so it
// grows forward instead, and a 45 deg buttress carries it down the wall inside
module tab_head2d() hull() { circle(r = TAB_R); polygon([[-eps, -TAB_R * sqrt(2)], [eps, -TAB_R * sqrt(2)], [0, 0]]); }
module tab2d() {
    tab_head2d();
    translate([-TAB_D, -HR - eps]) square([TAB_D, HR + eps]);
    let(uw = HR - WALL, d = uw + TAB_D)          // buttress under the part of the stem that overhangs the inside
        if (d > 0) polygon(uw < 0 ? [[-TAB_D, -HR + eps], [0, -HR + eps], [0, -HR - d], [uw, -HR - d]]
                                  : [[-TAB_D, -HR + eps], [0, -HR + eps], [0, -HR], [uw, -HR], [uw, -HR - d]]);   // flush with the seam behind the axis, where the lid lands at 90 deg
}

// pin along +z with flats on local x (they end up top and bottom), cone tip
module hinge_pin() intersection() {
    union() {
        cylinder(d = hinge_pin_d, h = PIN_L - 0.4 + eps);
        translate([0, 0, PIN_L - 0.4]) cylinder(d1 = hinge_pin_d, d2 = hinge_pin_d - 0.8, h = 0.4);
    }
    cube([hinge_pin_d - 2 * PIN_FLAT, 2 * hinge_pin_d, 3 * PIN_L], center = true);
}

module hinge_tabs(fs, H) let(a = hinge_axis(fs, H))
    for (tx = tab_xs(fs)) {
        along_axis(fs, H, tx - TAB_W / 2, tx + TAB_W / 2) tab2d();
        for (s = [-1, 1]) translate([tx + s * (TAB_W / 2 - eps), a[0], a[1]]) rotate([0, s * 90, 0]) hinge_pin();
    }

module hinge_cuts(fs, H) {
    L = mm(fs[0]); w = TAB_W / 2 + hinge_clear; hl = w + PIN_L + 0.3;
    ch = hinge_pin_d - 2 * PIN_FLAT + 0.2;                    // lead-in: lets the flatted pins through only at 90 deg
    along_axis(fs, H, -L / 2 - 1, L / 2 + 1)                  // round the lower back edge about the axis
        difference() { translate([0, -HR - 1]) square([HR + 1, HR + 1]); circle(r = HR, $fn = 96); }
    for (tx = tab_xs(fs)) {
        along_axis(fs, H, tx - w, tx + w) offset(r = hinge_clear) {
            // the tab as the lid sees it while turning 0..90 deg: head, its
            // tip swung round to the back, and the stem sweeping down and back
            hull() { tab_head2d(); rotate(90) tab_head2d(); }
            translate([-TAB_D, -HR - 1]) square([HR + 1 + TAB_D, HR + 1]);
        }
        along_axis(fs, H, tx - hl, tx + hl) {
            circle(d = hinge_pin_d + hinge_play);
            translate([-ch / 2, -HR - 1]) square([ch, HR + 1]);
        }
    }
}

// the lid's pose: hinged open by lid_open
module lid_pose(fs, H) let(a = hinge_axis(fs, H))
    translate([0, a[0], a[1]]) rotate([-lid_open, 0, 0]) translate([0, -a[0], -a[1]]) children();

// ---------------------------------------------------------------------
//  Detent, squeeze to open: a catch post stands on the front wall top, its
//  outer face set DT_U in from the outside, with a bead facing out. The
//  bead clicks into a groove in the lid's front skin, which comes down
//  outside the post. Squeeze the front of the box and the wall top bows
//  in, pulling the bead out of the groove, and the lid lifts free; the lid's
//  pocket over the post runs wide inside to give the wall room. Closing, the
//  skin rides down the bead and pushes the wall top in the same way. Every
//  face is vertical or 45 deg: no supports.
//  Front coordinates: u = in from the front face, v = up.
// ---------------------------------------------------------------------
function detent_xs(fs) = detent_count == 1 ? [0] : detent_count == 2 ? [-mm(fs[0]) / 4, mm(fs[0]) / 4] : [];

module along_front(fs, x0, x1)
    translate([x0, -mm(fs[1]) / 2, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) children();

DT_TOP = max(SEAT, DT_V + 0.4);   // post top: level with the ridge

// the post: vertical outer face, a 45 deg chamfer, then flat to the inner face
module detent_post2d(s) let(c = DT_U + DT_TOP - DT_V)
    polygon([[DT_U, s - 1], [DT_U, s + DT_V], [c, s + DT_TOP], [WALL, s + DT_TOP], [WALL, s - 1]]);

// the lid's pocket over it: the post widened inwards by relief (room for the wall to bow in),
// under a 45 deg gable so the lid prints without bridging
module detent_pocket2d(s, relief) let(c = DT_U + DT_TOP - DT_V, w = WALL + relief, m = (c + w) / 2)
    polygon([[DT_U, s - 1], [DT_U, s + DT_V], [c, s + DT_TOP], [m, s + DT_TOP + (w - c) / 2], [w, s + DT_TOP], [w, s - 1]]);

module detent_bead2d(s) let(b = detent_bump + lid_clear, z = s + DT_Z, f = DT_FLAT / 2)
    polygon([[DT_U + eps, z - b - f], [DT_U - b, z - f], [DT_U - b, z + f], [DT_U + eps, z + b + f]]);

// body: the ridge in front of the post comes off, then the post and bead go on
module detent_trim(fs, H) let(l = detent_len * PITCH + 0.6, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) translate([-1, s]) square([DT_U + 1, SEAT + 1]);

module detent_catches(fs, H) let(l = detent_len * PITCH, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2)
        intersection() { union() { detent_post2d(s); detent_bead2d(s); } translate([-1, s - eps]) square([WALL + 2, LID_H]); }

// lid: solid skin in place of the groove over the post, then the post's pocket and the bead's groove
module detent_fill(fs, H) let(l = detent_len * PITCH, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) translate([0, s]) square([WALL + lid_clear + eps, SEAT + lid_clear + eps]);

module detent_cuts(fs, H) let(l = detent_len * PITCH + 0.6, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) {
        offset(delta = lid_clear) detent_pocket2d(s, detent_bump + 0.2);
        offset(delta = 0.1) detent_bead2d(s);
    }

// ---------------------------------------------------------------------
//  Lid hollow: everything under the top skin inside the outer lip (the band
//  with the sloped groove edge) is open, except solid blocks round the
//  hinge slots and the detent pockets.
// ---------------------------------------------------------------------
module lid_hollow(fs, H) let(seam = H - LID_H,
        ins = len([for (s = SIDES) if (s == "sockets") s]) > 0 ? max(WALL - TIP, SOCKET_MIN) : WALL - TIP,   // the top of the groove slope, or room for wall sockets
        hx = TAB_W / 2 + hinge_clear + PIN_L + 0.3 + BEEF, hy = HR + TAB_D + hinge_clear + BEEF,
        dx = (detent_len * PITCH + 0.6) / 2 + BEEF, dy = WALL + lid_clear + detent_bump + 0.3 + BEEF)   // past the pocket
    difference() {
        translate([0, 0, seam - 1]) linear_extrude(LID_H - LID_TOP + 1) plan(fs, ins);
        for (tx = tab_xs(fs)) translate([tx - hx, mm(fs[1]) / 2 - hy, seam - 2]) cube([2 * hx, hy + 1, LID_H + 2]);
        for (x = detent_xs(fs)) translate([x - dx, -mm(fs[1]) / 2 - 1, seam - 2]) cube([2 * dx, dy + 1, LID_H + 2]);
    }

module box_body(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            difference() {
                union() {
                    linear_extrude(seam) plan(fs);
                    // hinged: no ridge where the lid's back edge swings down past it
                    front_of(fs, mm(fs[1]) / 2 - 2 * HR - 0.5) ridge(fs, seam - eps, RIM, SEAT);
                }
                translate([0, 0, FLOOR]) linear_extrude(seam + SEAT) plan(fs, WALL);
                detent_trim(fs, H);
            }
            side_faces(fs, H, 0, seam, "studs");
            if (bottom == "studs") for (x = cols(fs[0]), y = cols(fs[1])) translate([x, y, eps]) mirror([0, 0, 1]) stud();
            hinge_tabs(fs, H);
            detent_catches(fs, H);
        }
        // last, so nothing inside (the hinge buttresses reach down into the floor) fills them
        side_faces(fs, H, 0, seam, "sockets");
        if (bottom == "sockets") for (x = cols(fs[0]), y = cols(fs[1])) translate([x, y, 0]) socket();
    }
}

// lid in box coordinates: it sits on the seam, H - LID_H. Its underside has
// a 45 deg groove that drops over the wall ridge and centres it; inside that
// it is hollow. It prints inverted, top down.
module box_lid(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            difference() {
                translate([0, 0, seam]) linear_extrude(LID_H) plan(fs);
                // the groove stops at the axis; behind it the lid is solid over the wall
                front_of(fs, mm(fs[1]) / 2 - HR) ridge(fs, seam - 1, RIM - lid_clear - 1, SEAT + lid_clear + 1);
            }
            detent_fill(fs, H);
        }
        hinge_cuts(fs, H);
        detent_cuts(fs, H);
        lid_hollow(fs, H);
        side_faces(fs, H, seam, H, "sockets", seam + PITCH, true);
        // top sockets, except any that would reach down into a hinge slot
        if (top == "sockets") let(a = hinge_axis(fs, H), deep = H - SOCKET_H - 0.4 < a[1] + TAB_R + hinge_clear,
                                  sx = TAB_W / 2 + hinge_clear + socket_d / 2 + 0.4, sy = a[0] - TAB_R - hinge_clear - socket_d / 2 - 0.4)
            for (x = cols(fs[0]), y = cols(fs[1]))
                if (!(deep && y > sy && len([for (tx = tab_xs(fs)) if (abs(x - tx) < sx) tx]) > 0) && !in_label(fs, x, y))
                    translate([x, y, H]) mirror([0, 0, 1]) socket();
        if (LABEL && !RAISED && LABEL_D > 0) translate([0, 0, H - LABEL_D]) linear_extrude(LABEL_D + 1) label2d(fs);
    }
    // round the lid band, but not the back of its bottom row, which lands on the wall top at 90 deg
    side_faces(fs, H, seam, H, "studs", seam + PITCH, true);
    if (top == "studs") for (x = cols(fs[0]), y = cols(fs[1])) if (!in_label(fs, x, y)) translate([x, y, H - eps]) stud();
    if (LABEL && RAISED && LABEL_D > 0) translate([0, 0, H - eps]) linear_extrude(LABEL_D) label2d(fs);
}

body_color = [0.55, 0.56, 0.58];   // mid gray
lid_color  = [0.78, 0.79, 0.80];   // light gray, so the seam stays easy to see

module box() {
    color(body_color) render() box_body(FS, BH);
    color(lid_color) lid_pose(FS, BH) render() box_lid(FS, BH);
}

// ---------------------------------------------------------------------
//  Output
// ---------------------------------------------------------------------
echo(str("\n==== Parametric brick box ====",
    "\n  size     ", FS[0], " x ", FS[1], " studs (", round(mm(FS[0])), " x ", round(mm(FS[1])), " mm), ",
                     BH / PLATE, " plates (", BH, " mm) tall",
    "\n  row      ", row, ": side_rows ", side_rows, row > 0 ? str(" + ", row, " x rise ", rise) : "", " = ", ROWS, " stud rows, the top ", LID_ROWS, " on the lid\n"));
if (max(mm(FS[0]), mm(FS[1])) > max(bed_x, bed_y) || min(mm(FS[0]), mm(FS[1])) > min(bed_x, bed_y) || BH + (bottom == "studs" ? stud_h : 0) + TOP_TIP > bed_z)
    echo("WARNING: the box is too big for the printer bed");
if (WALL < 3.2) echo(str("NOTE: ", WALL, " mm walls leave a ", SEAT, " mm seat ridge and ", DT_U - lid_clear - detent_bump - 0.1, " mm of lid skin over the detent"));
if (WALL < SOCKET_MIN && len([for (s = SIDES) if (s == "sockets") s]) > 0)
    echo(str("WARNING: ", WALL, " mm walls leave only ", WALL - SOCKET_H, " mm behind the wall sockets - use ", SOCKET_MIN, " or more"));
if (FLOOR > floor_t) echo(str("NOTE: floor thickened to ", FLOOR, " mm for the bottom sockets"));
if (LID_TOP > lid_top) echo(str("NOTE: lid top thickened to ", LID_TOP, " mm for the top sockets"));
if (LABEL && (LABEL_BOX[1][0] - LABEL_BOX[0][0] > mm(FS[0]) - 2 * WALL || LABEL_BOX[1][1] - LABEL_BOX[0][1] > mm(FS[1]) - 2 * WALL))
    echo(str("WARNING: the label runs off the lid top - lower label_size or shorten the text"));
if (LABEL && LABEL_D < label_depth) echo(str("NOTE: label engraved ", LABEL_D, " mm deep, to leave 0.4 mm of the ", LID_TOP, " mm lid top under it - raise lid_top for deeper"));
if (tab_xs(FS)[1] < TAB_W / 2 + hinge_clear + PIN_L + 2)
    echo(str("WARNING: the box is too short for hinge tabs ", hinge_from_end, " studs from each end - lower hinge_from_end"));
if (let(l = detent_len * PITCH + 0.6, xs = detent_xs(FS))   // each detent inside the end walls, and two clear of each other
        detent_count > 0 && (abs(xs[0]) + l / 2 > mm(FS[0]) / 2 - WALL || (detent_count == 2 && xs[1] - l / 2 < 0)))
    echo(str("WARNING: ", detent_count, " detent", detent_count == 2 ? "s" : "", " ", detent_len, " studs long don't fit along the front - lower detent_len or detent_count"));

BODY_TIP = bottom == "studs" ? stud_h - eps : 0;   // body printed upright: its bottom studs reach the bed
LID_TIP = TOP_TIP > 0 ? TOP_TIP - eps : 0;   // lid printed inverted: its top studs (or raised label) reach the bed
module body_print() translate([0, 0, BODY_TIP]) render() box_body(FS, BH);
module lid_print() translate([0, 0, BH + LID_TIP]) rotate([180, 0, 0]) render() box_lid(FS, BH);
if (part == "assembled") box();
else if (part == "body") color(body_color) body_print();
else if (part == "lid") color(lid_color) lid_print();
else {   // print: body upright and lid inverted, side by side
    color(body_color) body_print();
    color(lid_color) translate([0, mm(FS[1]) + 15, 0]) lid_print();
}
