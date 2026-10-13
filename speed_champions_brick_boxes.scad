// =====================================================================
//  Speed Champions brick boxes
// =====================================================================
//
//  One printable box per car: a smooth, round-cornered box with recessed
//  studded panels, made for filling with real LEGO.
//    - every dimension is LEGO units: footprints in studs (8 mm pitch,
//      0.1 mm play per side), heights in plates (3.2 mm)
//    - flat top rim and flat, rounded corners
//    - a flat lid with studs standing on its top face, so plates press on
//      and pry off easily - studs everywhere, or just pads for the minifigs
//    - inset studded panels on all four sides; at the default depth of one
//      plate, plates and tiles pressed into them finish flush with the
//      frame - tile a mosaic, a stripe, a sponsor board, a name
//    - lid (the top band) over an open storage box: hinged on two tabs at
//      the back (friction pins, holds any angle up to 90 deg, lifts off at
//      90 deg), or a plain lift-off lid seated on a ridge
//
//  Panel openings are whole studs plus a little play, so an n-stud plate
//  drops in. Box height is set in side stud rows (side_rows, plus rise per
//  shelf row back), rounded up to whole plates. Rows are measured from the
//  top, so an even rise (2 rows = 16 mm = 5 plates) keeps the panels of
//  neighbouring boxes on one common grid.
//
//  Car size classes (envelope incl. tyres / mirrors / wings, in studs):
//    6w          6-wide era, 2015-2019            7 x 17
//    8w          8-wide road car, 2020+           9 x 21
//    8w_long     Le Mans / GT racers, pickups     9 x 24
//    f1_classic  F1 2020-2024, F1 Academy         9 x 23
//    f1_2025     2025+ F1 grid                   10 x 27
//    f1_mini     F1 Collectible Race Cars (71049)  5 x 11
//    mbs_speed   Mattel Brick Shop Hot Wheels     10 x 22
//                Speed Series, 1:32
//    coupon      test print: a mini box (5 x 6 studs with a minifig)
//                that checks side studs, top studs, panel and lid fit
//    custom      car_w / car_l
//  car_size sets every box; box_sizes overrides box by box.
//
//  Layout: boxes are packed onto the shelf in rows on the stud grid (not
//  drawn), each row taller than the one in front of it. The console lists
//  box number -> size / footprint / height.
//
//  Printing, no supports:
//    body  upright as modelled (open top up, flat floor on the bed); panel
//          ceilings slope back at 45 deg so they print without drooping
//    lid   top up: a 45 deg groove in its underside drops over a
//          ridge on the wall tops and centres itself
//  Hinge: the body's tabs print upright with flat-bottomed pins; the lid's
//  slots, pin holes and lead-ins all open downwards. To fit the lid, hold it
//  upright (open 90 deg) behind the tabs and slide it forward onto the pins,
//  then close it. Tune hinge_play for stiffness.
//  Side studs print as short horizontal pegs, with a small flat shaved off
//  their undersides (side_stud_flat) so the worst of the overhang is gone.
//  Print car_size = "coupon" first to tune stud_d / side_stud_d / lid_clear.
//  Export with box_n = N, part = print / body / lid.
// =====================================================================

/* [Box to print] */
// box to show / export; its height comes from its row on the shelf (see console)
box_n = 0;
part = "print";         // [print, body, lid, assembled]
// hinged lid: open it in previews, degrees
lid_open = 0;           // [0:5:90]
// lift-off lid: lift it in previews to see inside
lid_lift = 0;           // [0:1:60]
// ghost cars + minifigs (preview only)
show_cars = true;

/* [Shelf space] */
shelf_width_in = 30;
shelf_depth_in = 18;
// vertical space between cabinet shelves
shelf_clearance_in = 12;

/* [Car size] */
car_size = "8w";        // [6w, 8w, 8w_long, f1_classic, f1_2025, f1_mini, mbs_speed, coupon, custom]
// one entry per box, overrides car_size; empty = fill the shelf with car_size
box_sizes = [];
// custom: width in studs
car_w = 9;              // [4:1:12]
// custom: length in studs
car_l = 21;             // [6:1:32]

/* [Minifigs] */
// minifigs per box
fig_count = 1;          // [0:1:2]
// one entry per box (0-2), overrides fig_count
box_figs = [];
// studs added beside the car for the figures
fig_strip = 3;          // [2:1:6]
// where the figures stand, seen from the front: N = back, S = front, E = right end, W = left end; corners stand at that end of the back or front
fig_dir = "SE";        // [NE, N, NW, W, SW, S, SE, E]

/* [Box size] */
// flat border around every panel and the top area, studs
frame = 1;              // [1:1:3]
// rounding of the vertical edges, mm
corner_r = 5;           // [0:0.5:7]
// stud rows on the side panels of the front row of boxes - sets the box height
side_rows = 2;          // [1:1:30]
// extra stud rows per shelf row back (even numbers keep panels aligned)
rise = 6;               // [0:1:12]
// studs between boxes on the shelf (changes how many fit per row)
gap = 1;                // [0:1:4]

/* [Panels] */
// studs over the whole top area (off = plain, with stud pads for the minifigs only)
top_studs = true;
// minifig stud pad when top_studs is off, studs across
fig_pad_x = 2;          // [1:1:4]
// ... and front to back
fig_pad_y = 2;          // [1:1:4]
// side panel recess depth (3.2 = one plate, finishes flush)
panel_depth = 3.2;      // [0.8:0.8:4.8]
// longest panel in studs; longer faces split with flat mullions (0 = one panel)
panel_max = 0;          // [0:1:24]
// studs across each side panel, centred (0 = as many as fit)
side_cols = 0;          // [0:1:30]
// side studs: grid; checker = every other stud (still takes plates); diagonal = lattice at 45 deg
stud_pattern = "grid";  // [grid, checker, diagonal]
// extra opening clearance per side, on top of LEGO's 0.1
panel_play = 0.1;       // [0:0.05:0.4]
panels_front = true;
panels_back = true;
panels_left = true;
panels_right = true;

/* [Studs] */
// printed stud diameter - tune for clutch (LEGO 4.8)
stud_d = 4.85;          // [4.6:0.05:5.1]
stud_h = 1.8;           // [1.2:0.1:2]
// wall studs print sideways and size differently - tune separately
side_stud_d = 4.85;     // [4.6:0.05:5.1]
// flat shaved off the underside of wall studs, for a cleaner overhang
side_stud_flat = 0.4;   // [0:0.1:1]

/* [Box construction] */
// wall left behind a panel (half a plate)
skin = 1.6;             // [0.8:0.4:4]
// floor thickness (3.2 = 1 plate)
floor_t = 3.2;          // [1.6:0.8:6.4]
// recessed plinth round the bottom: hides the line where the solid floor shrinks and pulls the walls in (0 = off)
plinth_inset = 0.6;     // [0:0.1:1.5]
// how far the plinth reaches above the top of the floor
plinth_above = 0.6;     // [0:0.2:2]
// the same band round the top edge of the lid, mirroring the plinth at the bottom
lid_plinth = true;
// lift-off lid: play between lid groove and wall ridge
lid_clear = 0.2;        // [0:0.05:0.6]

/* [Lid hinge] */
// hinge: pivots on two tabs at the back; seat: lift-off lid on a ridge
lid_style = "hinge";    // [hinge, seat]
// studs from each end of the box to a hinge tab
hinge_from_end = 1;     // [1:1:6]
// pins on the tabs
hinge_pin_d = 3;        // [2.4:0.1:3.4]
// pin hole minus pin diameter - smaller = stiffer, so the lid holds its angle
hinge_play = 0.05;      // [-0.1:0.05:0.4]
// gap around the tabs in their slots
hinge_clear = 0.25;     // [0.1:0.05:0.5]

/* [Lid detent] */
// snap detents on the front lip: 1 = centred, 2 = a quarter in from each end (0 = off)
detent_count = 1;       // [0:1:2]
// detent length along the front, studs
detent_len = 2;         // [1:1:6]
// how far the front wall has to give to let the lid past - more = firmer snap
detent_bump = 0.3;      // [0.1:0.05:0.6]

/* [Printing] */
bed_x = 250;
bed_y = 250;
bed_z = 250;

/* [Hidden] */
PITCH = 8;              // stud pitch
PLATE = 3.2;            // plate height (brick = 3 plates)
PLAY = 0.1;             // LEGO play per side: n studs = n * 8 - 0.2 mm
CUSTOM_H = 16;          // custom car height in plates: only for the ghost and the shelf clearance check
// the figure strip runs along the front or back of the car, or across one end
ENDS = fig_dir == "E" || fig_dir == "W";                       // strip across an end, not along the front or back
FSIGN = ENDS ? (fig_dir == "E" ? 1 : -1) : (fig_dir[0] == "N" ? 1 : -1);   // which way the strip lies from the car
FALIGN = len(fig_dir) == 2 ? (fig_dir[1] == "E" ? 1 : -1) : 0;          // front / back: figures at the right end, left end or centred
LID_H = PITCH;          // lid band: it is also the border above the side panels
BOT_GAP = 1.5 * PLATE;  // smallest flat band under the panels
WALL = max(2.4, panel_depth + skin);
RIM = 1.2;              // flat lid rim on the wall top, outside the seat
TIP = 0.8;              // flat on the inner edge of the seat ridge
SEAT = max(0.4, WALL - RIM - TIP);   // height of the 45 deg seat ridge above the seam
PLINTH_H = floor_t + plinth_above;   // height of the recessed bands at the bottom of the body and top of the lid
HINGE = lid_style == "hinge";
HR = LID_H / 2;         // hinge axis: mid-height of the lid band, HR in from the back face
TAB_R = 2;              // hinge tab head radius
TAB_W = 6;              // tab thickness along the axis
TAB_D = 6;              // tab stem depth in front of the axis: a solid block, buttressed down the inside of the back wall
PIN_L = 1.5;            // pin length out of each tab face
PIN_FLAT = 0.5;         // flat on top and bottom of each pin: prints clean, and only passes the lead-in at 90 deg
DT_Z = 1.4;             // detent bead centre above the seam, on the inside of the wall ridge
DT_FLAT = 0.6;          // flat on the bead tip
eps = 0.01;
$fn = 40;

IN = 25.4;
SW = shelf_width_in * IN; SD = shelf_depth_in * IN; SH = shelf_clearance_in * IN;

function mm(n) = n * PITCH - 2 * PLAY;

// ---------------------------------------------------------------------
//  Sizes
// ---------------------------------------------------------------------
// [key, label, width studs, length studs, height plates]
CARS = [
    ["6w",         "6-wide",       7, 17, 13],
    ["8w",         "8-wide",       9, 21, 16],
    ["8w_long",    "8-wide long",  9, 24, 17],
    ["f1_classic", "F1 2020-24",   9, 23, 14],
    ["f1_2025",    "F1 2025+",    10, 27, 16],
    ["f1_mini",    "F1 mini",      5, 11,  8],   // 71049 collectible: 8 x 3.5 x 2.5 cm
    ["mbs_speed",  "MBS Speed",   10, 22, 15],   // Mattel Brick Shop Speed Series: MC20 8 x 4.5 x 16.5 cm, Avant RS2 6.5 in long
    ["coupon",     "coupon",       1,  3,  3],   // test print
];
CAR_KEYS = [for (c = CARS) c[0]];

// [w, l, h, label]
function car_of(key) = key == "custom" ? [car_w, car_l, CUSTOM_H, "custom"] :
    let(i = search([key], CAR_KEYS)[0]) i == [] ? car_of("8w") : [CARS[i][2], CARS[i][3], CARS[i][4], CARS[i][1]];

// footprint in studs: [length, width]
function foot(c, nf) = let(s = nf > 0 ? fig_strip : 0)
    ENDS ? [c[1] + 2 * frame + s, c[0] + 2 * frame] : [c[1] + 2 * frame, c[0] + 2 * frame + s];

// ---------------------------------------------------------------------
//  Layout: rows packed front to back, on the stud grid
// ---------------------------------------------------------------------
F0 = foot(car_of(car_size), fig_count);
N_AUTO = max(1, floor((SW + gap * PITCH) / (F0[0] * PITCH + gap * PITCH)))
       * max(1, floor((SD + gap * PITCH) / (F0[1] * PITCH + gap * PITCH)));
N = len(box_sizes) > 0 ? len(box_sizes) : car_size == "coupon" ? 1 : N_AUTO;   // a coupon is a single test box

function key_of(n) = n < len(box_sizes) ? box_sizes[n] : car_size;
function figs_of(n) = max(0, min(2, n < len(box_figs) ? box_figs[n] : fig_count));
function car_n(n) = car_of(key_of(n));
function foot_n(n) = foot(car_n(n), figs_of(n));

// [x0 stud, y0 stud, row] per box; a row ends when the next box won't fit
function pack(i = 0, x = 0, y = 0, r = 0, rd = 0, acc = []) =
    i >= N ? acc :
    let(f = foot_n(i))
    (x > 0 && (x + f[0]) * PITCH > SW) ? pack(i, 0, y + rd + gap, r + 1, 0, acc)
        : pack(i + 1, x + f[0] + gap, y, r, max(rd, f[1]), concat(acc, [[x, y, r]]));
L0 = pack();
NROWS = max([for (p = L0) p[2]]) + 1;
function row_dep(r) = max([for (i = [0:N - 1]) if (L0[i][2] == r) L0[i][1] + foot_n(i)[1]]);
DEPTH = row_dep(NROWS - 1);

function rows_of(n) = side_rows + L0[n][2] * rise;   // side stud rows
// height in whole plates: lid band + stud rows + at least BOT_GAP below them
function h_of(n) = ceil((LID_H + rows_of(n) * PITCH + 2 * panel_play + BOT_GAP) / PLATE - 1e-6);
function H_of(n) = h_of(n) * PLATE;               // mm

// ---------------------------------------------------------------------
//  Studs and panels
// ---------------------------------------------------------------------
function cols(n) = [for (i = [0:n - 1]) (i - (n - 1) / 2) * PITCH];

// side stud centres in a panel w wide, h high, relative to its centre: [[x, z], ...]
function panel_pts(w, h) = let(nx = round(w / PITCH), nz = round(h / PITCH))
    stud_pattern == "diagonal" ?
        let(n = ceil((w + h) / PITCH), s = PITCH / sqrt(2))
        [for (a = [-n:n], b = [-n:n]) let(x = (a - b) * s, z = (a + b) * s)
            if (abs(x) <= w / 2 - PITCH / 2 + eps && abs(z) <= h / 2 - PITCH / 2 + eps) [x, z]]
    : [for (i = [0:nx - 1], k = [0:nz - 1]) if (stud_pattern != "checker" || (i + k) % 2 == 0)
        [(i - (nx - 1) / 2) * PITCH, (k - (nz - 1) / 2) * PITCH]];

// snap a pad of n studs centred near f onto the stud grid of an a-stud area
function snap(f, a, n) = let(o = (a % 2 == 0 ? PITCH / 2 : 0) + (n % 2 == 0 ? PITCH / 2 : 0))
    round((f - o) / PITCH) * PITCH + o;
// centre of minifig i of nf in the strip; two stand side by side (one behind the other at an end)
function fig_spot(fs, nf, i) = let(a = [fs[0] - 2 * frame, fs[1] - 2 * frame], g = nf == 1 ? 0 : (i - 0.5) * 3 * PITCH)
    ENDS ? [snap(FSIGN * (a[0] - fig_strip) / 2 * PITCH, a[0], fig_pad_x), snap(g, a[1], fig_pad_y)]
    : [let(half = (nf == 1 ? 0 : 1.5 * PITCH) + fig_pad_x * PITCH / 2,      // half the group's width
           cx = FALIGN * (a[0] * PITCH / 2 - half))
       snap(cx + g, a[0], fig_pad_x),
       snap(FSIGN * (a[1] - fig_strip) / 2 * PITCH, a[1], fig_pad_y)];
// centre of the car: on whole studs, at the far end of the top area from the figures
function car_spot(fs, c) = let(a = [fs[0] - 2 * frame, fs[1] - 2 * frame])
    ENDS ? [-FSIGN * (a[0] - c[1]) / 2 * PITCH, ((a[1] - c[0]) % 2) * PITCH / 2]
         : [((a[0] - c[1]) % 2) * PITCH / 2, -FSIGN * (a[1] - c[0]) / 2 * PITCH];

// stud with a 0.3 mm chamfer on the tip, so plates find it and press on easily
module stud_shape(d) {
    cylinder(d = d, h = stud_h - 0.3 + eps, $fn = 48);
    translate([0, 0, stud_h - 0.3]) cylinder(d1 = d, d2 = d - 0.6, h = 0.3, $fn = 48);
}
module stud() stud_shape(stud_d);
// wall stud: local -y ends up pointing down, so that is where the flat goes
module side_stud() intersection() {
    stud_shape(side_stud_d);
    translate([-side_stud_d, -side_stud_d / 2 + side_stud_flat, -1]) cube([2 * side_stud_d, 2 * side_stud_d, stud_h + 2]);
}

// panels along a face of n studs: [[centre, width in studs], ...]
function panels(n) =
    let(a = n - 2 * frame,
        k = panel_max > 0 ? floor((a + frame) / (panel_max + 1 + frame)) + 1 : 1,   // fewest panels <= panel_max
        pw0 = floor((a - (k - 1) * frame) / k),                                      // widest that fits
        pw = side_cols > 0 ? min(side_cols, pw0) : pw0)
    a < 1 || pw < 1 ? [] :
    [for (i = [0:k - 1]) [(i - (k - 1) / 2) * (pw0 + frame) * PITCH, pw]];

// vertical extent of the side panels: [bottom, top, stud rows]
// The panels run right up to the seam, so the lid band is the border above them.
function panel_z(H) = let(top = H - LID_H, rows = floor((top - BOT_GAP) / PITCH))
    [top - rows * PITCH - 2 * panel_play, top, rows];

// one panel recess cut into a face lying in the x-z plane, outside towards -y.
// The ceiling slopes up 45 deg going in, so it prints without support.
module panel_cut(w, z0, z1, d) {
    hw = w / 2;
    hull() {
        translate([-hw, -1, z0]) cube([w, 1 + eps, z1 - z0]);
        translate([-hw, d - eps, z0]) cube([w, eps, z1 - z0 + d]);
    }
}

// side panels of a box: cuts (studs = false) or the studs inside them
module side_panels(fs, H, studs = false) {
    L = mm(fs[0]); W = mm(fs[1]); P = panel_z(H); d = panel_depth;
    faces = [[panels_front, 0, W / 2, fs[0]], [panels_back, 180, W / 2, fs[0]],
             [panels_right, 90, L / 2, fs[1]], [panels_left, -90, L / 2, fs[1]]];
    if (P[2] > 0) for (f = faces) if (f[0]) rotate(f[1]) translate([0, -f[2], 0])
        for (p = panels(f[3])) translate([p[0], 0, 0])
            if (!studs) panel_cut(p[1] * PITCH + 2 * panel_play, P[0], P[1], d);
            else for (q = panel_pts(p[1] * PITCH, P[2] * PITCH))
                translate([q[0], d + eps, P[1] - panel_play - P[2] * PITCH / 2 + q[1]]) rotate([90, 0, 0]) side_stud();
}

// ---------------------------------------------------------------------
//  Box: body + lid, split one stud pitch below the top
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
                                  : [[-TAB_D, -HR + eps], [uw, -HR + eps], [uw, -HR - d]]);
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

// the lid's pose: hinged open by lid_open, or lifted by lift
module lid_pose(fs, H, lift) let(a = hinge_axis(fs, H))
    if (HINGE) translate([0, a[0], a[1]]) rotate([-lid_open, 0, 0]) translate([0, -a[0], -a[1]]) children();
    else translate([0, 0, lift]) children();

// ---------------------------------------------------------------------
//  Detent: a bead along the inside of the front wall ridge clicks into a
//  matching groove in the lid's plug. Closing, the plug's lower edge rides
//  over the bead and the wall top springs out to let it by - the lid's own
//  groove is still well clear of the ridge at that point. Both bead faces
//  are 45 deg: no supports, and it pulls open again.
//  Front coordinates: u = in from the front face, v = up.
// ---------------------------------------------------------------------
function detent_xs(fs) = detent_count == 1 ? [0] : detent_count == 2 ? [-mm(fs[0]) / 4, mm(fs[0]) / 4] : [];

module along_front(fs, x0, x1)
    translate([x0, -mm(fs[1]) / 2, 0]) rotate([90, 0, 90]) linear_extrude(x1 - x0) children();

module detent_bead2d(seam) let(u = WALL, b = detent_bump + lid_clear, z = seam + DT_Z, f = DT_FLAT / 2)
    polygon([[u - eps, z - b - f], [u + b, z - f], [u + b, z + f], [u - eps, z + b + f]]);

module detent_beads(fs, H) let(l = detent_len * PITCH)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) detent_bead2d(H - LID_H);

module detent_cuts(fs, H) let(l = detent_len * PITCH + 0.6)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) offset(delta = 0.1) detent_bead2d(H - LID_H);

// Plinth: the bottom band of the body, up to just above the floor (its first big
// solid layers), is set in
// by plinth_inset with a 45 deg return above it (no overhang). The solid
// floor shrinks more than the walls as it cools and pulls them in; that step
// now lands on the plinth's edge instead of showing as a stray line.
module plinth_cut(fs, z0, h) let(i = plinth_inset)
    difference() {
        translate([0, 0, z0 - 1]) linear_extrude(h + i + 1) offset(delta = 5) plan(fs);
        hull() { slab(fs, z0 - 2, i); slab(fs, z0 + h, i); slab(fs, z0 + h + i + 0.5, -0.5); }
    }

// the same round the top of the lid, upside down: a band h deep below the top
// face z1 is set in, with the 45 deg return underneath (the lid prints top up)
module plinth_top_cut(fs, z1, h) let(i = plinth_inset)
    difference() {
        translate([0, 0, z1 - h - i]) linear_extrude(h + i + 1) offset(delta = 5) plan(fs);
        hull() { slab(fs, z1 - h - i - 0.5, -0.5); slab(fs, z1 - h, i); slab(fs, z1 + 2, i); }
    }

module box_body(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            linear_extrude(seam) plan(fs);
            // hinged: no ridge where the lid's back edge swings down past it
            if (HINGE) front_of(fs, mm(fs[1]) / 2 - 2 * HR - 0.5) ridge(fs, seam - eps, RIM, SEAT);
            else ridge(fs, seam - eps, RIM, SEAT);
        }
        translate([0, 0, floor_t]) linear_extrude(seam + SEAT) plan(fs, WALL);
        side_panels(fs, H);
        if (plinth_inset > 0) plinth_cut(fs, 0, PLINTH_H);
    }
    side_panels(fs, H, true);
    if (HINGE) hinge_tabs(fs, H);
    detent_beads(fs, H);
}

// lid in box coordinates: it sits on the seam, H - LID_H. Its underside has
// a 45 deg groove that drops over the wall ridge and a plug that fills the
// opening, so it prints top up with no overhang steeper than 45 deg.
module box_lid(fs, H, nf = 0) {
    seam = H - LID_H;
    a = [fs[0] - 2 * frame, fs[1] - 2 * frame];            // top area, studs
    difference() {
        union() {
            difference() {
                translate([0, 0, seam]) linear_extrude(LID_H) plan(fs);
                // hinged: the groove stops at the axis; behind it the lid is solid over the wall
                if (HINGE) front_of(fs, mm(fs[1]) / 2 - HR) ridge(fs, seam - 1, RIM - lid_clear - 1, SEAT + lid_clear + 1);
                else ridge(fs, seam - 1, RIM - lid_clear - 1, SEAT + lid_clear + 1);
            }
            translate([0, 0, seam]) linear_extrude(SEAT + lid_clear + eps) plan(fs, WALL + lid_clear);
        }
        if (HINGE) hinge_cuts(fs, H);
        detent_cuts(fs, H);
        if (plinth_inset > 0 && lid_plinth) plinth_top_cut(fs, H, PLINTH_H);
    }
    if (top_studs) for (x = cols(a[0]), y = cols(a[1])) translate([x, y, H - eps]) stud();
    else for (i = [0:1:nf - 1]) let(f = fig_spot(fs, nf, i))
        for (x = cols(fig_pad_x), y = cols(fig_pad_y)) translate([f[0] + x, f[1] + y, H - eps]) stud();
}

body_color = [0.55, 0.56, 0.58];   // mid gray
lid_color  = [0.78, 0.79, 0.80];   // light gray, so the seam stays easy to see

module box(n, lift = 0) {
    fs = foot_n(n); H = H_of(n);
    color(body_color) render() box_body(fs, H);
    color(lid_color) lid_pose(fs, H, lift) render() box_lid(fs, H, figs_of(n));
}

// ---------------------------------------------------------------------
//  Ghosts (preview only): car parked at the back, figures in front
// ---------------------------------------------------------------------
car_colors = [[0.85, 0.1, 0.1], [0.98, 0.78, 0.1], [0.1, 0.35, 0.8], [0.1, 0.55, 0.25],
              [0.95, 0.45, 0.05], [0.9, 0.9, 0.9], [0.1, 0.65, 0.75], [0.45, 0.2, 0.6]];

module ghost_car(c, ci) {
    w = c[0] * PITCH - 1; l = c[1] * PITCH - 1; h = c[2] * PLATE; r = h * 0.32;
    color(car_colors[ci % len(car_colors)]) {
        translate([-l / 2, -w / 2 + 3, r * 0.6]) cube([l, w - 6, h * 0.42]);
        translate([-l * 0.2, -w / 2 + 6, r * 0.6]) cube([l * 0.42, w - 12, h - r * 0.6]);
    }
    color([0.08, 0.08, 0.08]) for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * l * 0.32, sy * (w / 2 - 4), r]) rotate([90, 0, 0]) cylinder(r = r, h = 8, center = true);
}

module ghost_fig(ci) {
    color([0.1, 0.2, 0.6]) translate([-4, -2.5, 0]) cube([8, 5, 12.8]);
    color(car_colors[(ci + 3) % len(car_colors)]) translate([-5, -2.5, 12.8]) cube([10, 5, 12.8]);
    color([0.98, 0.82, 0.1]) translate([0, 0, 25.6]) cylinder(d = 8, h = 9.6);
}

module dressed_box(n) {
    fs = foot_n(n); c = car_n(n); H = H_of(n); nf = figs_of(n);
    box(n, lid_lift);
    if (show_cars && $preview) lid_pose(fs, H, lid_lift) translate([0, 0, H + stud_h]) {
        // car on whole studs, at the far end of the top area from the figures
        translate(concat(car_spot(fs, c), 0)) ghost_car(c, n);
        if (nf > 0) for (i = [0:nf - 1])
            translate(concat(fig_spot(fs, nf, i), 0)) ghost_fig(n + i);
    }
}

// ---------------------------------------------------------------------
//  Output
// ---------------------------------------------------------------------
TALL = max([for (n = [0:N - 1]) H_of(n) + car_n(n)[2] * PLATE]);
echo(str("\n==== Speed Champions brick boxes ====",
    "\n  shelf       ", round(SW), " x ", round(SD), " mm  (", floor(SW / PITCH), " x ", floor(SD / PITCH), " studs)",
    "\n  layout      ", N, " boxes in ", NROWS, " rows, ", DEPTH, " studs deep",
    "\n  heights     ", side_rows, " .. ", side_rows + (NROWS - 1) * rise, " stud rows",
    "\n  tallest     ", round(TALL), " of ", round(SH), " mm clearance (box + car)", "\n"));
for (n = [0:N - 1]) let(fs = foot_n(n), c = car_n(n), P = panel_z(H_of(n)))
    echo(str("  box ", n, ":  ", c[3], "  ", fs[0], " x ", fs[1], " studs (", round(mm(fs[0])), " x ", round(mm(fs[1])),
             " mm)  ", h_of(n), " plates (", H_of(n), " mm)  row ", L0[n][2], "  figs ", figs_of(n),
             "  side panels ", P[2], " row", P[2] == 1 ? "" : "s", " x ",
             [for (p = panels(fs[0])) p[1]], " / ", [for (p = panels(fs[1])) p[1]], " studs"));
for (k = concat([car_size], box_sizes))
    if (k != "custom" && search([k], CAR_KEYS)[0] == []) echo(str("WARNING: unknown car size \"", k, "\" - using 8w"));
if (DEPTH * PITCH > SD) echo(str("WARNING: layout is ", DEPTH, " studs deep - deeper than the shelf (", floor(SD / PITCH), ")"));
if (TALL > SH) echo(str("WARNING: tallest box + car is ", round(TALL), " mm - over the ", round(SH), " mm clearance"));
for (n = [0:N - 1]) let(fs = foot_n(n))
    if (max(mm(fs[0]), mm(fs[1])) > max(bed_x, bed_y) || min(mm(fs[0]), mm(fs[1])) > min(bed_x, bed_y) || H_of(n) > bed_z)
        echo(str("WARNING: box ", n, " is too big for the printer bed"));
if (corner_r > frame * PITCH - 1) echo("WARNING: corner_r is wider than the frame - corners will cut into the panels");
if (HINGE && WALL < HR + 0.4) echo(str("WARNING: walls (", WALL, " mm) are too thin for the hinge - raise panel_depth or skin to make them at least ", HR + 0.4, " mm"));
for (n = [0:N - 1]) let(fs = foot_n(n))
    if (HINGE && tab_xs(fs)[1] < TAB_W / 2 + hinge_clear + PIN_L + 2)
        echo(str("WARNING: box ", n, " is too short for hinge tabs ", hinge_from_end, " studs from each end - lower hinge_from_end"));
for (n = [0:N - 1]) if (plinth_inset > 0 && PLINTH_H + plinth_inset > panel_z(H_of(n))[0])
    echo(str("WARNING: box ", n, ": the plinth reaches up into the side panels - lower plinth_above"));
if (plinth_inset > 0 && lid_plinth && PLINTH_H + plinth_inset > LID_H - 1.5) echo(str("WARNING: the lid band (", PLINTH_H, " + ", plinth_inset, " mm) leaves under 1.5 mm of full-width lid - lower plinth_above or floor_t, or turn off lid_plinth"));
if (rise % 2 != 0) echo(str("NOTE: rise ", rise, " is odd - side panels of neighbouring rows will not line up"));
for (n = [0:N - 1]) let(fs = foot_n(n), P = panel_z(H_of(n)), w = max([0, for (p = concat(panels(fs[0]), panels(fs[1]))) p[1]]))
    if (side_cols > 0 && w < side_cols)
        echo(str("NOTE: box ", n, " only fits ", w, " columns - side_cols trimmed to fit"));
let(n = max(0, min(N - 1, box_n)), r = L0[n][2])
    echo(str("showing box ", n, ": row ", r, " -> side_rows ", side_rows, r > 0 ? str(" + ", r, " x rise ", rise) : " (front row: rise does not apply)", " = ", rows_of(n), " stud rows, ", h_of(n), " plates"));

BOX = max(0, min(N - 1, box_n)); FS = foot_n(BOX); BH = H_of(BOX);
LID_Z = -(BH - LID_H);       // lid's lowest point onto the bed
if (part == "assembled") dressed_box(BOX);
else if (part == "body") color(body_color) box_body(FS, BH);
else if (part == "lid") color(lid_color) translate([0, 0, LID_Z]) box_lid(FS, BH, figs_of(BOX));
else {   // print: body and lid side by side, both right way up
    color(body_color) box_body(FS, BH);
    color(lid_color) translate([0, mm(FS[1]) + 15, LID_Z]) box_lid(FS, BH, figs_of(BOX));
}
