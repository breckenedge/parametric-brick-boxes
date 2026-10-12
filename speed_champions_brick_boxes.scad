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
//    - removable lid (the top band) over an open storage box
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
//    custom      car_w / car_l / car_h
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
//  Side studs print as short horizontal pegs, with a small flat shaved off
//  their undersides (side_stud_flat) so the worst of the overhang is gone.
//  Print car_size = "coupon" first to tune stud_d / side_stud_d / lid_clear.
//  Export with box_n = N, part = print / body / lid.
// =====================================================================

/* [Box to print] */
box_n = 0;              // box to show / export; its height comes from its row on the shelf (see console)
part = "print";         // [print, body, lid, assembled]
lid_lift = 0;           // [0:1:60] lift the lid in previews to see inside
show_cars = true;       // ghost cars + minifigs (preview only)

/* [Shelf space] */
shelf_width_in = 30;
shelf_depth_in = 18;
shelf_clearance_in = 12;  // vertical space between cabinet shelves

/* [Car size] */
car_size = "8w";        // [6w, 8w, 8w_long, f1_classic, f1_2025, f1_mini, mbs_speed, coupon, custom]
// one entry per box, overrides car_size; empty = fill the shelf with car_size
box_sizes = [];
car_w = 9;              // [4:1:12] custom: width in studs
car_l = 21;             // [10:1:32] custom: length in studs
car_h = 16;             // [8:1:30] custom: height in plates

/* [Minifigs] */
fig_count = 1;          // [0:1:2] minifigs per box
// one entry per box (0-2), overrides fig_count
box_figs = [];
fig_strip = 3;          // [2:1:6] studs added in front of the car for the figures
fig_side = "right";     // [left, center, right] where the figures stand along the front strip, seen from the front

/* [Box size] */
frame = 1;              // [1:1:3] flat border around every panel and the top area, studs
corner_r = 5;           // [0:0.5:7] rounding of the vertical edges, mm
side_rows = 2;          // [1:1:30] stud rows on the side panels of the front row of boxes - sets the box height
rise = 6;               // [0:1:12] extra stud rows per shelf row back (even numbers keep panels aligned)
gap = 1;                // [0:1:4] studs between boxes on the shelf (changes how many fit per row)

/* [Panels] */
top_studs = true;       // studs over the whole top area (off = plain, with stud pads for the minifigs only)
fig_pad_x = 2;          // [1:1:4] minifig stud pad when top_studs is off, studs across
fig_pad_y = 2;          // [1:1:4] ... and front to back
panel_depth = 3.2;      // [0.8:0.8:4.8] side panel recess depth (3.2 = one plate, finishes flush)
panel_max = 0;          // [0:1:24] longest panel in studs; longer faces split with flat mullions (0 = one panel)
side_cols = 0;          // [0:1:30] studs across each side panel, centred (0 = as many as fit)
// side stud layout: square grid; checker = every other stud, a 45 deg look that still takes
// ordinary plates; diagonal = full lattice turned 45 deg (plates go on at 45 deg)
stud_pattern = "grid";     // [grid, checker, diagonal]
panel_play = 0.1;       // [0:0.05:0.4] extra opening clearance per side, on top of LEGO's 0.1
panels_front = true;
panels_back = true;
panels_left = true;
panels_right = true;

/* [Studs] */
stud_d = 4.85;          // [4.6:0.05:5.1] printed stud diameter - tune for clutch (LEGO 4.8)
stud_h = 1.7;           // [1.2:0.1:2]
side_stud_d = 4.85;     // [4.6:0.05:5.1] wall studs print sideways and size differently - tune separately
side_stud_flat = 0.4;   // [0:0.1:1] flat shaved off the underside of wall studs, for a cleaner overhang

/* [Box construction] */
skin = 1.6;             // [0.8:0.4:4] wall left behind a panel (half a plate)
floor_t = 3.2;          // [1.6:0.8:6.4] 1 plate
lid_clear = 0.2;        // [0:0.05:0.6] play between lid groove and wall ridge

/* [Printing] */
bed_x = 250;
bed_y = 250;
bed_z = 250;

/* [Hidden] */
PITCH = 8;              // stud pitch
PLATE = 3.2;            // plate height (brick = 3 plates)
PLAY = 0.1;             // LEGO play per side: n studs = n * 8 - 0.2 mm
LID_H = PITCH;          // lid band: it is also the border above the side panels
BOT_GAP = 1.5 * PLATE;  // smallest flat band under the panels
WALL = max(2.4, panel_depth + skin);
RIM = 1.2;              // flat lid rim on the wall top, outside the seat
TIP = 0.8;              // flat on the inner edge of the seat ridge
SEAT = max(0.4, WALL - RIM - TIP);   // height of the 45 deg seat ridge above the seam
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
function car_of(key) = key == "custom" ? [car_w, car_l, car_h, "custom"] :
    let(i = search([key], CAR_KEYS)[0]) i == [] ? car_of("8w") : [CARS[i][2], CARS[i][3], CARS[i][4], CARS[i][1]];

// footprint in studs: [length, width]
function foot(c, nf) = [c[1] + 2 * frame, c[0] + 2 * frame + (nf > 0 ? fig_strip : 0)];

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
// centre of minifig i of nf: in the strip in front of the car, side by side when there are two
function fig_spot(fs, nf, i) = [
    let(gx = nf == 1 ? 0 : (i - 0.5) * 3 * PITCH,                       // offset within a pair
        half = (nf == 1 ? 0 : 1.5 * PITCH) + fig_pad_x * PITCH / 2,     // half the group's width
        cx = fig_side == "center" ? 0 : (fig_side == "right" ? 1 : -1) * ((fs[0] - 2 * frame) * PITCH / 2 - half))
    snap(cx + gx, fs[0] - 2 * frame, fig_pad_x),
    snap((-fs[1] / 2 + frame + fig_strip / 2) * PITCH, fs[1] - 2 * frame, fig_pad_y)];

module stud() cylinder(d = stud_d, h = stud_h + eps, $fn = 48);
// wall stud: local -y ends up pointing down, so that is where the flat goes
module side_stud() intersection() {
    cylinder(d = side_stud_d, h = stud_h + eps, $fn = 48);
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

module box_body(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            linear_extrude(seam) plan(fs);
            ridge(fs, seam - eps, RIM, SEAT);
        }
        translate([0, 0, floor_t]) linear_extrude(seam + SEAT) plan(fs, WALL);
        side_panels(fs, H);
    }
    side_panels(fs, H, true);
}

// lid in box coordinates: it sits on the seam, H - LID_H. Its underside has
// a 45 deg groove that drops over the wall ridge and a plug that fills the
// opening, so it prints top up with no overhang steeper than 45 deg.
module box_lid(fs, H, nf = 0) {
    seam = H - LID_H;
    a = [fs[0] - 2 * frame, fs[1] - 2 * frame];            // top area, studs
    union() {
        difference() {
            translate([0, 0, seam]) linear_extrude(LID_H) plan(fs);
            ridge(fs, seam - 1, RIM - lid_clear - 1, SEAT + lid_clear + 1);
        }
        translate([0, 0, seam]) linear_extrude(SEAT + lid_clear + eps) plan(fs, WALL + lid_clear);
    }
    if (top_studs) for (x = cols(a[0]), y = cols(a[1])) translate([x, y, H - eps]) stud();
    else for (i = [0:1:nf - 1]) let(f = fig_spot(fs, nf, i))
        for (x = cols(fig_pad_x), y = cols(fig_pad_y)) translate([f[0] + x, f[1] + y, H - eps]) stud();
}

body_color = [0.80, 0.10, 0.10];
lid_color  = [0.15, 0.15, 0.16];

module box(n, lift = 0) {
    fs = foot_n(n); H = H_of(n);
    color(body_color) render() box_body(fs, H);
    color(lid_color) translate([0, 0, lift]) render() box_lid(fs, H, figs_of(n));
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
    if (show_cars && $preview) translate([0, 0, H + stud_h + lid_lift]) {
        // car centred on whole studs, against the back of the top area
        translate([((fs[0] - c[1]) % 2) * PITCH / 2, (fs[1] / 2 - frame - c[0] / 2) * PITCH, 0]) ghost_car(c, n);
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
