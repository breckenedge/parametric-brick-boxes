// =====================================================================
//  Parametric brick boxes
// =====================================================================
//
//  A printable storage box, studded all over, made for building on with
//  real LEGO.
//    - every dimension is LEGO units: footprints in studs (8 mm pitch,
//      0.1 mm play per side), heights in stud rows (8 mm)
//    - studs edge to edge over every side, from the bed up to the seam,
//      and a row round the lid band (not its back, which lands on the wall
//      top at 90 deg)
//    - a flat, hollow lid with studs standing on its top face, so plates press on
//      and pry off easily (or a plain top, with top_studs off)
//    - lid (the top band) over an open storage box, hinged on two tabs at
//      the back (friction pins, holds any angle up to 90 deg, lifts off at
//      90 deg)
//
//  Box height is set in side stud rows: side_rows, plus rise for each shelf
//  row back (see row), plus the lid band's row. Every box is whole stud
//  rows tall, so the side studs of neighbouring boxes line up.
//
//  Box size is studs_l x studs_w, the whole footprint.
//
//  Printing:
//    body  upright as modelled (open top up, flat floor on the bed), no
//          supports
//    lid   inverted: top down, open underside up. Its top studs land on
//          the bed and need supports (or set top_studs off for a flat
//          top); everything else - the 45 deg
//          groove edge, hinge slots, detent pocket - opens upwards
//  Hinge: the body's tabs print upright with flat-bottomed pins. To fit the
//  lid, hold it upright (open 90 deg) behind the tabs and slide it forward
//  onto the pins, then close it. Tune hinge_play for stiffness.
//  Side studs print as short horizontal pegs, with a small flat shaved off
//  the side facing down as printed (side_stud_flat) so the worst of the
//  overhang is gone.
//  Print stud_fit_test.scad, then a 6 x 5 box, to tune stud_d / side_stud_d / lid_clear.
//  Set row for where the box stands on the shelf, then export with part = print / body / lid.
// =====================================================================

/* [Box to print] */
part = "print";         // [print, body, lid, assembled]
// open the lid in previews, degrees
lid_open = 0;           // [0:5:90]

/* [Box size] */
// box length, left to right, studs (the whole footprint)
studs_l = 21;           // [5:1:40]
// box width, front to back, studs
studs_w = 12;           // [5:1:30]
// stud rows on the sides of a front-row box, under the lid band - sets the box height
side_rows = 2;          // [1:1:30]
// extra stud rows for each row further back
rise = 6;               // [0:1:12]
// shelf row the box is for, 0 = front: each row back is rise stud rows taller, so whatever stands on the boxes in back sits higher
row = 0;                // [0:1:6]
// rounding of the vertical edges, mm (the corner studs start 1.5 mm in)
corner_r = 1;           // [0:0.25:1.5]

/* [Studs] */
// studs over the whole top (off = plain)
top_studs = true;
studs_front = true;
studs_back = true;
studs_left = true;
studs_right = true;
// printed stud diameter - tune for clutch (LEGO 4.8)
stud_d = 4.85;          // [4.6:0.05:5.1]
stud_h = 1.8;           // [1.2:0.1:2]
// wall studs print sideways and size differently - tune separately
side_stud_d = 4.85;     // [4.6:0.05:5.1]
// flat shaved off the underside of wall studs, for a cleaner overhang
side_stud_flat = 0.4;   // [0:0.1:1]

/* [Box construction] */
// wall thickness, mm (under 3.2 the lid's seat ridge and the skin over the detent get thin)
wall = 3.2;             // [2.4:0.4:6]
// floor thickness (3.2 = 1 plate)
floor_t = 3.2;          // [1.6:0.8:6.4]
// play between the lid groove and the wall ridge
lid_clear = 0.2;        // [0:0.05:0.6]
// lid top skin thickness: under it the lid is hollow, inside the outer lip
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

/* [Printing] */
bed_x = 250;
bed_y = 250;
bed_z = 250;

/* [Hidden] */
PITCH = 8;              // stud pitch, and the height of a side stud row
PLATE = 3.2;            // plate height (brick = 3 plates)
PLAY = 0.1;             // LEGO play per side: n studs = n * 8 - 0.2 mm
LID_H = PITCH;          // lid band: one row of side studs
WALL = wall;
RIM = 1.2;              // flat lid rim on the wall top, outside the seat
TIP = 0.8;              // flat on the inner edge of the seat ridge
SEAT = max(0.4, WALL - RIM - TIP);   // height of the 45 deg seat ridge above the seam
HR = LID_H / 2;         // hinge axis: mid-height of the lid band, HR in from the back face
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
eps = 0.01;
$fn = 40;

function mm(n) = n * PITCH - 2 * PLAY;

// ---------------------------------------------------------------------
//  Size
// ---------------------------------------------------------------------
FS = [max(5, round(studs_l)), max(5, round(studs_w))];   // footprint, studs
ROWS = side_rows + row * rise;   // side stud rows under the lid band
BH = (ROWS + 1) * PITCH;         // box height, mm: those rows and the lid band's

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
module side_stud(top = false) intersection() {
    stud_shape(side_stud_d);
    mirror([0, top ? 1 : 0, 0])
        translate([-side_stud_d, -side_stud_d / 2 + side_stud_flat, -1]) cube([2 * side_stud_d, 2 * side_stud_d, stud_h + 2]);
}

// one stud grid over each whole side, body and lid band together, standing
// straight off the wall. Each part takes the studs between z0 and z1; any
// that would straddle the seam are left out.
module side_studs(fs, H, z0, z1, back = true, top = false) {
    L = mm(fs[0]); W = mm(fs[1]); r = side_stud_d / 2;
    faces = [[studs_front, 0, W / 2, fs[0]], [studs_back && back, 180, W / 2, fs[0]],
             [studs_right, 90, L / 2, fs[1]], [studs_left, -90, L / 2, fs[1]]];
    for (f = faces) if (f[0]) rotate(f[1]) translate([0, -f[2], 0])
        for (q = face_pts(f[3] * PITCH, H))
            let(z = H / 2 + q[1]) if (z - r > z0 && z + r < z1)
                translate([q[0], eps, z]) rotate([90, 0, 0]) side_stud(top);
}

// ---------------------------------------------------------------------
//  Box: body + lid, split one stud row below the top
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
//  The axis runs along x at mid-height of the lid band, HR in from the back
//  face. The lid's lower back edge is rounded about it, so as the lid opens
//  nothing behind the axis ever drops below the seam, and everything in
//  front of it rises. At 90 deg the lid's back face lands on the wall top:
//  that is the stop. Hinge coordinates: u = towards the back, v = up.
// ---------------------------------------------------------------------
function hinge_axis(fs, H) = [mm(fs[1]) / 2 - HR, H - HR];      // [y, z]
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
module lid_hollow(fs, H) let(seam = H - LID_H, ins = WALL - TIP,   // the top of the groove slope
        hx = TAB_W / 2 + hinge_clear + PIN_L + 0.3 + BEEF, hy = HR + TAB_D + hinge_clear + BEEF,
        dx = (detent_len * PITCH + 0.6) / 2 + BEEF, dy = WALL + lid_clear + detent_bump + 0.3 + BEEF)   // past the pocket
    difference() {
        translate([0, 0, seam - 1]) linear_extrude(LID_H - lid_top + 1) plan(fs, ins);
        for (tx = tab_xs(fs)) translate([tx - hx, mm(fs[1]) / 2 - hy, seam - 2]) cube([2 * hx, hy + 1, LID_H + 2]);
        for (x = detent_xs(fs)) translate([x - dx, -mm(fs[1]) / 2 - 1, seam - 2]) cube([2 * dx, dy + 1, LID_H + 2]);
    }

module box_body(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            linear_extrude(seam) plan(fs);
            // hinged: no ridge where the lid's back edge swings down past it
            front_of(fs, mm(fs[1]) / 2 - 2 * HR - 0.5) ridge(fs, seam - eps, RIM, SEAT);
        }
        translate([0, 0, floor_t]) linear_extrude(seam + SEAT) plan(fs, WALL);
        detent_trim(fs, H);
    }
    side_studs(fs, H, 0, seam);
    hinge_tabs(fs, H);
    detent_catches(fs, H);
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
    }
    // round the lid band, but not the back, which lands on the wall top at 90 deg
    side_studs(fs, H, seam, H, false, true);
    if (top_studs) for (x = cols(fs[0]), y = cols(fs[1])) translate([x, y, H - eps]) stud();
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
    "\n  row      ", row, ": side_rows ", side_rows, row > 0 ? str(" + ", row, " x rise ", rise) : "", " = ", ROWS, " stud rows + 1 on the lid\n"));
if (max(mm(FS[0]), mm(FS[1])) > max(bed_x, bed_y) || min(mm(FS[0]), mm(FS[1])) > min(bed_x, bed_y) || BH > bed_z)
    echo("WARNING: the box is too big for the printer bed");
if (WALL < 3.2) echo(str("NOTE: ", WALL, " mm walls leave a ", SEAT, " mm seat ridge and ", DT_U - lid_clear - detent_bump - 0.1, " mm of lid skin over the detent"));
if (tab_xs(FS)[1] < TAB_W / 2 + hinge_clear + PIN_L + 2)
    echo(str("WARNING: the box is too short for hinge tabs ", hinge_from_end, " studs from each end - lower hinge_from_end"));

LID_TIP = top_studs ? stud_h - eps : 0;   // lid printed inverted: its top studs reach the bed
module lid_print() translate([0, 0, BH + LID_TIP]) rotate([180, 0, 0]) box_lid(FS, BH);
if (part == "assembled") box();
else if (part == "body") color(body_color) box_body(FS, BH);
else if (part == "lid") color(lid_color) lid_print();
else {   // print: body upright and lid inverted, side by side
    color(body_color) box_body(FS, BH);
    color(lid_color) translate([0, mm(FS[1]) + 15, 0]) lid_print();
}
