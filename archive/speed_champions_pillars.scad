// =====================================================================
//  Free-standing gallery pillars for LEGO Speed Champions
// =====================================================================
//
//  One pillar per car, no base plate - print them one at a time and
//  arrange them however you like. Every pillar carries:
//    - a recessed parking pad sized for the car's class
//    - a stud patch so the car's minifig can stand beside it
//      (printed studs, or a pocket for a real LEGO plate = perfect clutch)
//    - an optional engraved nameplate on the front of the cap
//
//  Car size classes (envelope incl. tyres / mirrors / wings, approx.):
//    6w          6-wide era, 2015-2019     body 6 studs = 48 mm
//    8w          8-wide road car, 2020+    body 8 studs = 64 mm, ~15-17 cm long
//    8w_long     long 8-wide: Le Mans / GT racers, pickups, two-seater limos
//    f1_classic  8-wide F1 2020-2024 and F1 Academy (~18 cm)
//    f1_2025     2025+ F1 grid (~20 cm long, ~7 cm wide)
//    custom      uses car_w / car_l / car_h
//  car_size sets every pillar; pillar_sizes overrides pillar by pillar.
//
//  Body styles (body_style, or pillar_styles pillar by pillar):
//    classic    chamfered foot + cap        fluted     greek-style grooves
//    waisted    pinched at mid-height       twisted    gentle twist
//    colonnade  ring of fluted half-columns with bases and capitals
//    deco       art-deco fin groups and a stepped, corbelled crown
//    knurled    diamond knurling, like a machined grip
//    checker    chequered-flag squares cut into the faces
//    voronoi    see-through voronoi cage (or cells carved into the shaft)
//    arcade     tiers of arches on piers (see-through or blind)
//    egyptian   battered walls, cavetto cornice, glyph columns, name cartouche
//    quilted    diamond-stitched quilting with contrast stitching
//    woven      diagonal basket weave, in the style of woven leather goods
//    monogram   canvas-style repeat of your initials, studs and flowers in greek-key bands
//  Fancier styles need some height; a pillar too short for its style is
//  built as classic and the console says so. "mixed" puts the fancy ones
//  on the tall back pillars.
//
//  Heights come in rows: the "arrangement" preview lays the pillars out
//  on the shelf so the back rows stand taller than the front rows, and
//  the console prints a table of pillar number -> size / height / style.
//
//  Minifigs: fig_count (0-2) for every pillar, pillar_figs pillar by pillar.
//  Two figures stand side by side; 0 drops the figure zone entirely.
//
//  Removable tops: each pillar splits into a body and a top (the cap band
//  with the car pad, studs and nameplate), keyed by a ridge and groove, so
//  tops can be printed in another colour or swapped between bodies of the
//  same shape and size. With container = true the body under the lid is
//  hollowed into an open-top storage box (walls kept clear of every
//  style's surface detail).
//
//  Printing: stand upright as modelled, no supports (all overhangs <= 45
//  deg). Bodies are solid - let the slicer hollow them (2-3 walls, 10-15 %
//  infill) - except the voronoi cage, which is hollow by design.
//  Export with output = "pillar", pillar_n = N, part = print / body / top.
// =====================================================================

/* [Output] */
output = "arrangement"; // [arrangement, pillar, lineup]
pillar_n = 0;           // pillar to export (numbers listed in the console)
show_cars = true;       // ghost cars in the preview
show_figs = true;       // ghost minifigs in the preview

/* [Shelf space] */
shelf_width_in = 30;
shelf_depth_in = 18;
shelf_clearance_in = 12;  // vertical space between cabinet shelves
fit_clearance = 2;        // mm left free on every side

/* [Car size] */
car_size = "8w";  // [6w:6-wide (2015-2019), 8w:8-wide road car (2020+), 8w_long:8-wide long (Le Mans / GT / truck), f1_classic:F1 2020-2024 + F1 Academy, f1_2025:F1 2025+, custom:Custom (car_w / car_l / car_h)]
pillar_sizes = [];  // per-pillar override, e.g. ["f1_2025", "6w", "8w"] - pillar n gets pillar_sizes[n]
car_w = 70;         // custom only: width incl. tyres / mirrors
car_l = 165;        // custom only: length
car_h = 50;         // custom only: height (for headroom)

/* [Pillar heights] */
front_h = 30;      // front-row pillar height
rise = 55;         // wanted height step between rows (auto-reduced to fit)
row_jitter = 6;    // neighbours in a row alternate up/down by this (kept below rise/2)
headroom = 30;     // min gap between the tallest car roof and the shelf above

/* [Pillar shape] */
shape = "mixed";        // [mixed, rounded, squircle, octagon]
body_style = "mixed";   // [mixed, classic, fluted, waisted, twisted, colonnade, deco, knurled, checker, voronoi, arcade, egyptian, quilted, woven, monogram]
pillar_styles = [];     // per-pillar override, e.g. ["voronoi", "", "colonnade"] - "" keeps body_style
rim = 6;                // flat border around the car pad
corner_r = 10;          // rounded shape corner radius
base_t = 7;             // plinth foot band height
cap_t = 10;             // cap band height (nameplate lives here)
inset = 6;              // shaft inset from foot / cap (45 deg chamfers)
waist = 5;              // extra pinch at mid-height for "waisted"
twist = 8;              // total twist for "twisted" (auto-limited)
flute_r = 1.6;          // groove radius for "fluted"
flute_pitch = 9;
foot_chamfer = 0.6;     // elephant-foot relief at the very bottom

/* [Body style details] */
col_r = 6;              // colonnade: column radius
col_pitch = 4.5;        // colonnade: column spacing, in column radii
col_flutes = 12;        // colonnade: grooves per column
deco_fin = 3;           // deco: fin thickness
deco_group = 30;        // deco: spacing between fin groups
deco_drop = 14;         // deco: how much shorter the side fins are
deco_depth = 6;         // deco: how far the fins stand proud
knurl_pitch = 4;        // knurled: diamond size
knurl_depth = 1;        // knurled: groove depth
quilt_size = 18;        // quilted: diamond size
quilt_depth = 1.2;      // quilted: seam depth
quilt_stitch = 1.6;     // quilted: stitch length
weave_size = 14;        // woven: weave cell (two strips)
weave_depth = 1.5;      // woven: groove depth
mono_text = "SC";       // monogram: your initials (1-3 letters)
mono_size = 20;         // monogram: repeat spacing
mono_key = 6;           // monogram: greek-key band height (0 = none)
mono_depth = 0.7;       // monogram: engraving depth
vor_mode = "cage";      // [cage, relief]  cage = hollow + see-through, relief = cells carved 2 mm deep
vor_cell = 18;          // voronoi: cell size
vor_strut = 3;          // voronoi: strut width between cells
vor_round = 1.5;        // voronoi: cell corner rounding
cage_wall = 3;          // voronoi cage / open arcade: wall thickness
arc_mode = "open";      // [open, blind]  open = hollow + see-through arches, blind = arches recessed into the shaft
arc_tier_h = 55;        // arcade: wanted height of one tier of arches (tall shafts stack tiers)
arc_ratio = 1.7;        // arcade: arch height / width
arc_pier = 6;           // arcade: pier width between arches
arc_band = 6;           // arcade: solid band between tiers
arc_course = 1.5;       // arcade: how far the string course between tiers stands out
arc_depth = 2.5;        // arcade blind: recess depth (inner arch goes twice as deep)
arc_reveal = 2.5;       // arcade blind: inset of the inner arch
egy_batter = 4;         // egyptian: how far the walls lean in, bottom to top
egy_glyph = 7;          // egyptian: glyph size
egy_stroke = 1;         // egyptian: glyph line width
egy_depth = 0.8;        // egyptian: engraving depth
egy_name_size = 6;      // egyptian: max text size of the name in the front cartouche
vor_depth = 2;          // voronoi relief: carve depth
checker_size = 8;       // checker: square size (8 = one stud)
checker_depth = 1;

/* [Removable tops] */
removable_top = true;   // split each pillar into body + top (cap band with the car pad and studs)
part = "print";         // [print, body, top, assembled]  what output = "pillar" exports
top_lift = 0;           // preview: float the tops this far above the bodies
lip_in = 3;             // ridge inset from the edge
lip_w = 3;              // ridge width
lip_h = 3;              // ridge height
top_clear = 0.2;        // groove clearance per side
container = true;       // with removable tops: hollow each body into an open-top box under its lid
box_wall = 2.4;         // container wall, measured inside the deepest surface detail
box_floor = 3;          // container floor thickness

/* [Minifig] */
fig_pos = "alternate";  // [alternate:Ends (alternating), right:Right end, left:Left end, front:Front edge, back:Back edge, front_step:Front ledge (lowered), none:None]
fig_count = 1;          // minifigs per pillar, 0-2
pillar_figs = [];       // per-pillar override, e.g. [1, 2, 0, 1] - pillar n gets pillar_figs[n]
fig_studs_x = 2;        // stud patch size (per minifig)
fig_studs_y = 2;
fig_margin = 3;         // free space around the stud patch
step_drop = 16;         // front_step: how far the figure ledge sits below the car
fig_along = 0.7;        // front / back / front_step: figure position along the edge (0 centre, 1 end)
stud_mode = "printed";  // [printed, lego_plate]
stud_d = 4.85;          // printed stud diameter - tune for your printer's clutch
stud_h = 1.8;
plate_clear = 0.15;     // lego_plate: pocket clearance per side

/* [Layout preview] */
yaw = 4;           // pillars alternate +/- this angle
gap = 14;          // space between pillars in a row
aisle = 12;        // space between rows
stagger = true;    // offset every other row by half a pillar

/* [Details] */
pad_style = "recess";  // [recess, outline, none]
pad_depth = 0.8;
pad_clear = 2.5;       // pad size beyond the car envelope, per side
names = [];            // e.g. ["FERRARI F40", "MCLAREN SOLUS GT", ...] - pillar n gets names[n]
name_size = 5.5;
name_depth = 0.8;
font = "Liberation Sans:style=Bold";

/* [Printing] */
bed_x = 250;
bed_y = 250;
bed_z = 250;

/* [Hidden] */
$fn = 48;
IN = 25.4;
eps = 0.01;

W  = shelf_width_in * IN - 2 * fit_clearance;
D  = shelf_depth_in * IN - 2 * fit_clearance;
HC = shelf_clearance_in * IN;

function lerp(a, b, t) = a + (b - a) * t;
function pick(v, s, dflt) = let(i = search([s], v)[0]) i == [] ? dflt : i;

// ---------------------------------------------------------------------
//  Car size classes: [key, label, width, length, height]
// ---------------------------------------------------------------------
CARS = [
    ["6w",         "6-wide",       56, 135, 42],
    ["8w",         "8-wide",       70, 165, 50],
    ["8w_long",    "8-wide long",  72, 190, 55],
    ["f1_classic", "F1 2020-24",   72, 185, 45],
    ["f1_2025",    "F1 2025+",     76, 210, 50],
];
CAR_KEYS = [for (c = CARS) c[0]];

// [w, l, h, label]
function car_dims(key) = key == "custom" ? [car_w, car_l, car_h, "custom"] :
    let(c = CARS[pick(CAR_KEYS, key, 1)]) [c[2], c[3], c[4], c[1]];
function size_key(n) = n < len(pillar_sizes) ? pillar_sizes[n] : car_size;

fig_end  = fig_pos == "alternate" || fig_pos == "right" || fig_pos == "left";
fig_step = fig_pos == "front_step";
fig_y    = fig_step || fig_pos == "front" || fig_pos == "back";   // figure zone along a long edge
fzx = fig_studs_x * 8 + 2 * fig_margin;   // stud zone along the car
fzy = fig_studs_y * 8 + 2 * fig_margin;   // stud zone across the car (ledge depth)

// minifigs per pillar, 0..2 (0 drops the figure zone, so the pillar gets shorter)
function figs_of(n) = fig_pos == "none" ? 0 :
    max(0, min(2, round(n < len(pillar_figs) ? pillar_figs[n] : fig_count)));

// pillar geometry for a car: [padL, padW, Lt, Wt, car dims, minifigs]
function geo(cd, nf = 1) = let(pL = cd[1] + 2 * pad_clear, pW = cd[0] + 2 * pad_clear)
    [pL, pW, pL + 2 * rim + (fig_end && nf > 0 ? fzx : 0), pW + 2 * rim + (fig_y && nf > 0 ? fzy : 0), cd, nf];
function geo_of(n) = geo(car_dims(size_key(n)), figs_of(n));

// ---------------------------------------------------------------------
//  Layout: rows front to back, staggered, heights rising with depth.
//  Spacing uses the biggest size class in play so any pillar fits anywhere.
// ---------------------------------------------------------------------
USED = [for (k = concat([car_size], pillar_sizes)) geo(car_dims(k), fig_pos == "none" ? 0 : 1)];
LtM  = max([for (g = USED) g[2]]);
WtM  = max([for (g = USED) g[3]]);
HcarM = max([for (g = USED) g[4][2]]);

ey = LtM * sin(abs(yaw)) + WtM * cos(yaw);
nr = max(1, floor((D + aisle) / (ey + aisle)));
rd = D / nr;

// rows are filled in pillar order, each pillar taking its real footprint
function ex_of(n) = let(g = geo_of(n)) g[2] * cos(yaw) + g[3] * sin(abs(yaw));
function row_fit(n0, k = 0, w = 0) = let(nw = w + ex_of(n0 + k) + (k > 0 ? gap : 0))
    nw <= W && k < 60 ? row_fit(n0, k + 1, nw) : k;
function row_counts(r = 0, n0 = 0, acc = []) = r >= nr ? acc :
    let(f = max(1, row_fit(n0)), cnt = stagger && r % 2 == 1 && f > 1 ? f - 1 : f)
    row_counts(r + 1, n0 + cnt, concat(acc, [cnt]));
function cumsum(v, i = 0, acc = [0]) = i >= len(v) ? acc : cumsum(v, i + 1, concat(acc, [acc[i] + v[i]]));
RC = row_counts();
R0 = cumsum(RC);
nm = max(RC);

max_top  = min(HC - HcarM - headroom, bed_z - 2);
min_h    = (fig_step ? step_drop : 0) + base_t + cap_t + 2;
front_ok = max(front_h, min_h + row_jitter);
rise_eff = nr <= 1 ? 0 : max(0, min(rise, (max_top - front_ok - row_jitter) / (nr - 1)));
jit      = max(0, min(row_jitter, nr <= 1 ? row_jitter : rise_eff / 2 - 1));

SH = ["rounded", "squircle", "octagon"];
BS = ["classic", "fluted", "waisted", "twisted", "colonnade", "deco", "knurled", "checker", "voronoi", "arcade", "egyptian", "quilted", "woven", "monogram"];
MIX = [10, 13, 8, 11, 9, 4, 12, 6, 1, 5, 7, 3, 2, 0];   // "mixed": fanciest styles on the tallest (back) pillars
function shape_of(r, c) = shape == "mixed" ? (r + c) % 3 : pick(SH, shape, 0);
function side_of(r, c)  = fig_pos == "left" ? -1 : fig_pos != "right" && (r + c) % 2 == 1 ? -1 : 1;

// [x, y, yaw, row, col, height, shape, (unused), fig side]
P = [for (r = [0:nr - 1])
    let(n0 = R0[r], cnt = RC[r], exs = [for (k = [0:cnt - 1]) ex_of(n0 + k)],
        cs = cumsum(exs), s = (W - cs[cnt]) / cnt)   // leftover space shared evenly
    for (c = [0:cnt - 1])
        [s / 2 + cs[c] + c * s + exs[c] / 2, (r + 0.5) * rd,
         yaw * ((r + c) % 2 == 0 ? 1 : -1), r, c,
         front_ok + r * rise_eff + (c % 2 == 0 ? jit : -jit),
         shape_of(r, c), 0, side_of(r, c)]];

function body_of(n) = n < len(pillar_styles) && pillar_styles[n] != "" ? pick(BS, pillar_styles[n], 0) :
                      body_style == "mixed" ? MIX[(len(P) - 1 - n) % len(MIX)] : pick(BS, body_style, 0);

// where things sit on a pillar, in pillar coordinates
function pad_at(p, g) = g[5] == 0 ? [0, 0] : fig_end ? [-p[8] * fzx / 2, 0] :
                        [0, fig_pos == "back" ? -fzy / 2 : fzy / 2];
// stud patches: one per minifig; two stand side by side
fig_sep = fig_studs_y * 8 + 2;
function fig_spots(p, g) = g[5] == 0 ? [] :
    fig_end ? [for (i = [0:g[5] - 1]) [p[8] * g[0] / 2, g[5] == 1 ? 0 : (i - 0.5) * fig_sep, p[5]]]
            : [for (i = [0:g[5] - 1]) let(x0 = p[8] * fig_along * (g[0] / 2 - fzx / 2))
                  [x0 - p[8] * i * (fig_studs_x * 8 + 4),
                   (fig_pos == "back" ? 1 : -1) * (g[3] / 2 - fzy / 2),
                   fig_step ? p[5] - step_drop : p[5]]];

// ---------------------------------------------------------------------
//  Pillar geometry
// ---------------------------------------------------------------------
module plan(sh, g) {
    Lt = g[2]; Wt = g[3];
    if (sh == 0) {
        offset(r = corner_r) square([Lt - 2 * corner_r, Wt - 2 * corner_r], center = true);
    } else if (sh == 1) {
        n = 10; a = Lt / 2; b = Wt / 2;
        polygon([for (t = [0:3:357]) let(c = cos(t), s = sin(t))
            [a * sign(c) * pow(abs(c), 2 / n), b * sign(s) * pow(abs(s), 2 / n)]]);
    } else {
        hx = Lt / 2; hy = Wt / 2; ch = rim * 1.6;
        polygon([[-hx + ch, -hy], [hx - ch, -hy], [hx, -hy + ch], [hx, hy - ch],
                 [hx - ch, hy], [-hx + ch, hy], [-hx, hy - ch], [-hx, -hy + ch]]);
    }
}

module slab(sh, g, z, off = 0, rot = 0) {
    translate([0, 0, z]) rotate(rot) linear_extrude(eps) offset(delta = off) plan(sh, g);
}

// vertical layout of a pillar body: [inset, foot top, shaft bottom, shaft top, cap bottom]
function body_z(Hc) = let(ins = max(0, min(inset, (Hc - base_t - cap_t) / 2 - 1)),
                          z0 = min(base_t, Hc - cap_t), z3 = Hc - cap_t)
    [ins, z0, z0 + ins, z3 - ins, z3];

// --- fluted ----------------------------------------------------------
module flutes(g, z1, z2, ins) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins;
    zs = z1 + 3 + flute_r; ze = z2 - 3 - flute_r;
    nx = floor(1.4 * hx / flute_pitch);
    ny = floor(1.0 * hy / flute_pitch);
    if (ze > zs) {
        for (i = [0:nx], sy = [-1, 1]) hull() for (z = [zs, ze])
            translate([(i - nx / 2) * flute_pitch, sy * hy, z]) sphere(r = flute_r, $fn = 16);
        for (j = [0:ny], sx = [-1, 1]) hull() for (z = [zs, ze])
            translate([sx * hx, (j - ny / 2) * flute_pitch, z]) sphere(r = flute_r, $fn = 16);
    }
}

// --- colonnade: core wall ringed by fluted half-columns --------------
module fluted2d(r) {
    difference() {
        circle(r = r, $fn = 48);
        for (k = [0:col_flutes - 1]) rotate(k * 360 / col_flutes)
            translate([r, 0]) circle(r = r * PI / col_flutes * 0.6, $fn = 12);
    }
}

module column(h, rc, fl) {
    capE = rc + fl - rc * 0.88;      // 45 deg echinus from the tapered shaft out to the abacus
    ab = 2.5;
    translate([0, 0, -fl]) cylinder(r = rc + fl, h = fl + 1.5);              // plinth, sits on the foot chamfer
    translate([0, 0, 1.5]) cylinder(r1 = rc + fl, r2 = rc, h = fl);          // base moulding
    translate([0, 0, 1.5 + fl - eps]) linear_extrude(h - 1.5 - fl - capE - ab + 2 * eps, scale = 0.88)
        fluted2d(rc);                                                         // tapered fluted shaft
    translate([0, 0, h - ab - capE]) cylinder(r1 = rc * 0.88, r2 = rc + fl, h = capE);
    translate([0, 0, h - ab]) linear_extrude(ab) square(2 * (rc + fl), center = true);   // abacus
}

module colonnade(sh, g, z1, z2, ins) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins;
    rc = min(col_r, hy / 3); fl = min(2.5, ins);
    h = z2 - z1;
    span = 2 * (hx - rc - 4);
    n = max(2, round(span / (col_pitch * rc)) + 1);
    translate([0, 0, z1 - eps]) linear_extrude(h + 2 * eps) offset(delta = -ins - rc) plan(sh, g);
    for (i = [0:n - 1], s = [-1, 1]) translate([-span / 2 + i * span / (n - 1), s * (hy - rc), z1]) column(h, rc, fl);
    for (s = [-1, 1]) translate([s * (hx - rc), 0, z1]) column(h, rc, fl);
}

// --- deco: vertical fins rising into a corbelled, stepped crown ------
// fins come in groups of three; centre fins run up into the crown,
// side fins stop short (flat tops - no overhang)
module deco_fins2d(hx, hy, fd, mid) {
    fs = deco_fin + 3;
    xe = hx - fd - corner_r;
    ng = max(1, floor(2 * xe / deco_group));
    for (i = [0:ng - 1], o = mid ? [0] : [-fs, fs])
        let(w = mid ? deco_fin * 1.5 : deco_fin)
            translate([(i - (ng - 1) / 2) * deco_group + o - w / 2, -hy - 1]) square([w, 2 * hy + 2]);
    for (s = [-1, 1], o = mid ? [0] : [-fs, fs])
        let(w = mid ? deco_fin * 1.5 : deco_fin)
            translate([s > 0 ? hx - fd - 1 : -hx - 1, o - w / 2]) square([fd + 2, w]);
}

module deco(sh, g, z1, z2, ins) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins;
    fd = min(deco_depth, hy / 4); h = z2 - z1;
    nb = 3; bh = 5; zc = z2 - nb * bh;
    translate([0, 0, z1 - eps]) linear_extrude(h + 2 * eps) offset(delta = -ins - fd) plan(sh, g);
    for (mid = [true, false])
        translate([0, 0, z1 - eps]) linear_extrude(zc - z1 + eps - (mid ? 0 : min(deco_drop, (zc - z1) / 3)))
            intersection() { offset(delta = -ins) plan(sh, g); deco_fins2d(hx, hy, fd, mid); }
    translate([0, 0, z1]) linear_extrude(4) offset(delta = -ins) plan(sh, g);    // plinth band
    for (k = [0:nb - 1]) let(zk = zc + k * bh,                                    // stepped crown
                             o0 = -ins - fd + fd * k / nb, o1 = -ins - fd + fd * (k + 1) / nb) {
        hull() { slab(sh, g, zk, o0); slab(sh, g, zk + fd / nb, o1); }            // 45 deg corbel
        translate([0, 0, zk + fd / nb]) linear_extrude(z2 - zk - fd / nb + eps) offset(delta = o1) plan(sh, g);
    }
}

// --- checker: chequered-flag recesses on the flat faces --------------
module checker_cut(sh, g, z1, z2, ins) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins; ck = checker_size; d = checker_depth;
    ex = sh == 1 ? 0.35 * hx : max(corner_r, rim * 1.6) + 1;
    ey = sh == 1 ? 0.35 * hy : max(corner_r, rim * 1.6) + 1;
    nz = floor((z2 - z1 - 4) / ck); zb = (z1 + z2 - nz * ck) / 2;
    nx = floor(2 * (hx - ex) / ck); xb = -nx * ck / 2;
    ny = floor(2 * (hy - ey) / ck); yb = -ny * ck / 2;
    if (nz > 0) {
        for (i = [0:1:nx - 1], j = [0:nz - 1], s = [-1, 1]) if ((i + j) % 2 == 0)
            translate([xb + i * ck, s * hy - d, zb + j * ck]) cube([ck, 2 * d, ck]);
        for (i = [0:1:ny - 1], j = [0:nz - 1], s = [-1, 1]) if ((i + j) % 2 == 1)
            translate([s * hx - d, yb + i * ck, zb + j * ck]) cube([2 * d, ck, ck]);
    }
}

// --- voronoi: see-through cage, or cells carved into a solid shaft ---
module halfplane(p, q) {   // the side of the p-q bisector that holds p
    L = 1000;
    translate((p + q) / 2) rotate(atan2(q[1] - p[1], q[0] - p[0])) translate([-L, -L]) square([L, 2 * L]);
}

// voronoi cells filling [-w, w] x [zlo, zhi] with struts between them.
// roof = true trims each cell to a 45 deg pointed top, so see-through
// windows print without supports (a little gothic, on purpose).
module vor2d(w, zlo, zhi, seed, roof) {
    s = vor_cell; st = vor_strut;
    nx = ceil(2 * w / s) + 3; nz = ceil((zhi - zlo) / (0.87 * s)) + 3;
    R = rands(0, 1, 2 * nx * nz, seed);
    pts = [for (i = [0:nx - 1], j = [0:nz - 1]) let(k = 2 * (i * nz + j))
        [-w - s + (i + 0.5 * (j % 2) + (R[k] - 0.5) * 0.7) * s,
         zlo - s + (j + (R[k + 1] - 0.5) * 0.7) * 0.87 * s]];
    intersection() {
        translate([-w + st / 2, zlo + st / 2]) square([2 * w - st, zhi - zlo - st]);
        union() for (p = pts) {
            nb = [for (q = pts) if (q != p && norm(q - p) < 2.5 * s) q];
            top = roof ? let(a = p[1] + 0.55 * s)
                    [[p[0] - 4 * s, a - 4 * s], [p[0], a], [p[0] + 4 * s, a - 4 * s], [p[0] + 4 * s, a - 9 * s], [p[0] - 4 * s, a - 9 * s]]
                  : [[p[0] - 4 * s, p[1] - 4 * s], [p[0] + 4 * s, p[1] - 4 * s], [p[0] + 4 * s, p[1] + 4 * s], [p[0] - 4 * s, p[1] + 4 * s]];
            offset(r = vor_round) offset(delta = -st / 2 - vor_round) intersection() {
                translate(p - [2 * s, 2 * s]) square(4 * s);
                intersection_for(q = nb) halfplane(p, q);
                polygon(top);
            }
        }
    }
}

module voronoi_cut(sh, g, z1, ztop, ins, seed, cage) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins;
    mx = sh == 1 ? 0.3 * hx : max(corner_r, rim * 1.6) + cage_wall;   // keep solid corner posts
    my = sh == 1 ? 0.3 * hy : max(corner_r, rim * 1.6) + cage_wall;
    zlo = z1 + 2; zhi = ztop - 2;
    if (zhi - zlo > vor_cell) {
        if (cage) {
            rotate([90, 0, 0]) linear_extrude(2 * hy + 10, center = true) vor2d(hx - mx, zlo, zhi, seed, true);
            rotate([90, 0, 90]) linear_extrude(2 * hx + 10, center = true) vor2d(hy - my, zlo, zhi, seed + 1, true);
        } else for (s = [-1, 1]) {
            translate([0, s * hy, 0]) rotate([90, 0, 0]) linear_extrude(2 * vor_depth, center = true)
                vor2d(hx - mx, zlo, zhi, seed + (s > 0 ? 2 : 0), false);
            translate([s * hx, 0, 0]) rotate([90, 0, 90]) linear_extrude(2 * vor_depth, center = true)
                vor2d(hy - my, zlo, zhi, seed + (s > 0 ? 3 : 1), false);
        }
    }
}

// --- arcade: rows of arches on piers, stacked in tiers when tall -----
// round arch with a small 45 deg point at the crown, so it prints unsupported
module arch2d(w, h) {
    r = w / 2; hs = h - r * sqrt(2);
    intersection() {
        union() {
            translate([-r, 0]) square([w, max(hs, 0) + eps]);
            translate([0, hs]) hull() {
                circle(r = r, $fn = 48);
                translate([0, r * sqrt(2) - eps]) square(2 * eps, center = true);
            }
        }
        translate([-r, 0]) square([w, h]);
    }
}

// [bottom, top, tiers, tier height] of the arcade on a shaft
function arc_geom(z1, ztop) = let(zlo = z1 + 3, zhi = ztop - 3,
                                  tiers = max(1, round((zhi - zlo) / arc_tier_h)))
    [zlo, zhi, tiers, (zhi - zlo) / tiers];

module arches2d(wf, A) {
    th = A[3]; ah = th - arc_band;
    n = max(1, round((wf + arc_pier) / (ah / arc_ratio + arc_pier)));
    aw = min((wf - (n - 1) * arc_pier) / n, ah * 1.3);
    for (t = [0:A[2] - 1], i = [0:n - 1])
        translate([(i - (n - 1) / 2) * (aw + arc_pier), A[0] + t * th + arc_band / 2]) arch2d(aw, ah);
}

module arcade_cut(sh, g, z1, ztop, ins, open) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins;
    mx = sh == 1 ? 0.3 * hx : max(corner_r, rim * 1.6) + cage_wall;   // solid corner posts
    my = sh == 1 ? 0.3 * hy : max(corner_r, rim * 1.6) + cage_wall;
    A = arc_geom(z1, ztop);
    if (A[3] > arc_band + 14) {
        if (open) {
            rotate([90, 0, 0]) linear_extrude(2 * hy + 10, center = true) arches2d(2 * (hx - mx), A);
            rotate([90, 0, 90]) linear_extrude(2 * hx + 10, center = true) arches2d(2 * (hy - my), A);
        } else for (s = [-1, 1], k = [0, 1]) let(d = arc_depth * (k + 1), o = -k * arc_reveal) {
            // blind arches: a shallow arch with a deeper, smaller one inside it
            translate([0, s * hy, 0]) rotate([90, 0, 0]) linear_extrude(2 * d, center = true)
                offset(delta = o) arches2d(2 * (hx - mx), A);
            translate([s * hx, 0, 0]) rotate([90, 0, 90]) linear_extrude(2 * d, center = true)
                offset(delta = o) arches2d(2 * (hy - my), A);
        }
    }
}

// string courses between tiers: flat top, 45 deg underside
module arcade_bands(sh, g, z1, ztop, ins) {
    A = arc_geom(z1, ztop);
    if (A[3] > arc_band + 14) for (t = [1:1:A[2] - 1]) let(zc = A[0] + t * A[3] - 1.5) {
        hull() { slab(sh, g, zc, -ins); slab(sh, g, zc + arc_course, -ins + arc_course); }
        translate([0, 0, zc + arc_course]) linear_extrude(1.5) offset(delta = -ins + arc_course) plan(sh, g);
    }
}

// cage interior: open-topped under a removable top, otherwise a 45 deg
// hipped roof so the ceiling never has to bridge
function cav_za(g, Z) = Z[4] - 2 - (g[3] / 2 - Z[0] - cage_wall);
function is_cage(bs, g, Z) = ((bs == 8 && vor_mode == "cage") || (bs == 9 && arc_mode == "open")) &&
    (removable_top || cav_za(g, Z) >= Z[2] + 30);

module cavity(sh, g, Z) {
    o = -Z[0] - cage_wall; z1 = Z[2];
    if (removable_top) translate([0, 0, z1]) linear_extrude(Z[4] - z1 + 1) offset(delta = o) plan(sh, g);
    else let(hyc = g[3] / 2 + o, hxc = g[2] / 2 + o, za = cav_za(g, Z)) hull() {
        translate([0, 0, z1]) linear_extrude(za - z1) offset(delta = o) plan(sh, g);
        translate([-(hxc - hyc), -0.5, za + hyc - 1]) cube([2 * (hxc - hyc), 1, 1]);
    }
}

// --- egyptian: battered walls, cavetto cornice, glyph columns, cartouche
egy_sand  = [0.87, 0.77, 0.56];
egy_lapis = [0.16, 0.27, 0.58];

module stroke(a, b, w) hull() { translate(a) circle(d = w, $fn = 12); translate(b) circle(d = w, $fn = 12); }
module strokes(pts, w) for (i = [0:len(pts) - 2]) stroke(pts[i], pts[i + 1], w);
module ring2d(r, w, sx = 1) difference() { scale([sx, 1]) circle(r = r, $fn = 32); scale([sx, 1]) circle(r = r - w, $fn = 32); }
module lens2d(wd, ht) let(r = (wd * wd / 4 + ht * ht / 4) / ht, c = r - ht / 2)
    intersection() { translate([0, -c]) circle(r = r, $fn = 48); translate([0, c]) circle(r = r, $fn = 48); }

EGY_GLYPHS = 9;
// glyphs in a 10 x 10 box around the origin, line width w
module glyph(k, w) {
    if (k == 0) {                                   // ankh
        translate([0, 2.2]) ring2d(2.5, w, 0.75);
        stroke([0, -4.6], [0, -0.3], w); stroke([-3, -0.6], [3, -0.6], w);
    } else if (k == 1) {                            // eye of Horus, simplified
        translate([0, 1.6]) difference() { lens2d(8.6, 3.8); offset(delta = -w) lens2d(8.6, 3.8); }
        translate([0, 1.6]) circle(r = 1.2, $fn = 16);
        stroke([-1, -0.3], [-1, -4.4], w);
        strokes([[1, -0.3], [2.6, -2.6], [4.1, -3.1], [4.3, -1.9]], w);
    } else if (k == 2) {                            // water
        for (y = [-2.2, 0, 2.2]) translate([0, y])
            strokes([for (i = [0:6]) [-4.5 + i * 1.5, (i % 2 == 0 ? 0.8 : -0.8)]], w);
    } else if (k == 3) {                            // djed pillar
        stroke([0, -4.5], [0, 1.6], 2.2 * w); stroke([-2.2, -4.5], [2.2, -4.5], w);
        for (y = [2.1, 3.4, 4.7]) stroke([-2.6, y], [2.6, y], w);
    } else if (k == 4) {                            // sun disc
        ring2d(3.8, w); circle(r = 1.2, $fn = 16);
    } else if (k == 5) {                            // wheel (also the glyph for "town")
        ring2d(4.2, w); stroke([-3, -3], [3, 3], w); stroke([-3, 3], [3, -3], w);
    } else if (k == 6) {                            // racing car
        difference() {
            union() {
                translate([0, -0.9]) offset(r = 0.8) square([8, 1.8], center = true);
                polygon([[-2.4, 0], [2, 0], [1.1, 2.2], [-1.5, 2.2]]);
            }
            for (x = [-2.7, 2.7]) translate([x, -2.1]) circle(r = 1.6, $fn = 16);
        }
        for (x = [-2.7, 2.7]) translate([x, -2.1]) circle(r = 1.1, $fn = 16);
    } else if (k == 7) {                            // reed leaf
        translate([0, 1.3]) lens2d(2.6, 6.6); stroke([0, -4.6], [0, -1.6], w);
    } else {                                        // chequered flag
        stroke([-3.6, -4.6], [-3.6, 4.6], w);
        for (i = [0:2], j = [0:1]) if ((i + j) % 2 == 0)
            translate([-3 + i * 2.2, 1.2 + j * 1.6]) square([2.2, 1.6]);
        difference() { translate([-3, 1.2]) square([6.6, 3.2]); translate([-3 + w / 2, 1.2 + w / 2]) square([6.6 - w, 3.2 - w]); }
    }
}

module stadium2d(wd, ht) hull() for (s = [-1, 1]) translate([0, s * (ht / 2 - wd / 2)]) circle(d = wd, $fn = 40);

// one face: border lines, glyph columns with dividers, optional cartouche
module egy_face2d(wf, zlo, zhi, seed, name, cart) {
    sc = egy_glyph / 10; w = egy_stroke / sc; lw = egy_stroke * 0.7;
    pitch = egy_glyph + 2.5;
    cw = cart ? min(wf * 0.3, 22) : 0;
    ng = max(1, floor((zhi - zlo - 2) / pitch));
    blocks = cart ? [[-wf / 2, -cw / 2 - 3], [cw / 2 + 3, wf / 2]] : [[-wf / 2, wf / 2]];
    R = rands(0, 1, 400, seed);
    for (s = [zlo, zhi]) stroke([-wf / 2, s], [wf / 2, s], lw);
    for (bi = [0:len(blocks) - 1]) let(b = blocks[bi], nc = floor((b[1] - b[0]) / pitch),
                                        x0 = b[0] + (b[1] - b[0] - nc * pitch) / 2)
        if (nc > 0) {
            for (i = [0:nc]) stroke([x0 + i * pitch, zlo], [x0 + i * pitch, zhi], lw);
            for (i = [0:nc - 1], j = [0:ng - 1])
                translate([x0 + (i + 0.5) * pitch, zhi - 1 - (j + 0.5) * pitch]) scale(sc)
                    glyph(floor(R[(bi * 20 + i * 7 + j * 3) % 400] * EGY_GLYPHS), w);
        }
    if (cart) let(ch = zhi - zlo - 8, cy = (zlo + zhi) / 2 + 1.5) {
        translate([0, cy]) difference() { stadium2d(cw, ch); offset(delta = -egy_stroke) stadium2d(cw, ch); }
        stroke([-cw / 2, cy - ch / 2 - 2], [cw / 2, cy - ch / 2 - 2], egy_stroke * 1.4);   // cartouche base bar
        if (name != "")
            translate([0, cy]) rotate(90)
                text(name, size = min(cw * 0.45, egy_name_size, (ch - cw * 0.6) / (0.72 * len(name))),
                     font = font, halign = "center", valign = "center");
        else let(n = max(1, floor((ch - cw * 0.5) / pitch)))
            for (j = [0:n - 1]) translate([0, cy + (n / 2 - j - 0.5) * pitch]) scale(sc)
                glyph(j == 0 ? 6 : floor(R[300 + j] * EGY_GLYPHS), w);
    }
}

// heights of the egyptian shaft: [shaft top, cornice start]
function egy_z(z3, ins) = let(G = ins + egy_batter, zr = z3 - 2.414 * G) [zr - 3, zr];

module egy_cuts(sh, g, z1, zt, ins, seed, name) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins; d = egy_depth;
    mx = sh == 1 ? 0.3 * hx : max(corner_r, rim * 1.6) + 2;
    my = sh == 1 ? 0.3 * hy : max(corner_r, rim * 1.6) + 2;
    zlo = z1 + 4; zhi = zt - 4;
    kk = egy_batter / (zt - z1);        // the walls lean in by kk per mm of height
    if (zhi - zlo > egy_glyph + 6) for (s = [-1, 1]) {
        multmatrix([[1, 0, 0, 0], [0, 1, -s * kk, s * kk * z1], [0, 0, 1, 0], [0, 0, 0, 1]])
            translate([0, s * hy, 0]) rotate([90, 0, 0]) linear_extrude(2 * d, center = true)
                egy_face2d(2 * (hx - mx - egy_batter), zlo, zhi, seed * 5 + (s > 0 ? 1 : 0), s < 0 ? name : "", true);
        multmatrix([[1, 0, -s * kk, s * kk * z1], [0, 1, 0, 0], [0, 0, 1, 0], [0, 0, 0, 1]])
            translate([s * hx, 0, 0]) rotate([90, 0, 90]) linear_extrude(2 * d, center = true)
                egy_face2d(2 * (hy - my - egy_batter), zlo, zhi, seed * 5 + (s > 0 ? 3 : 2), "", false);
    }
}

module egyptian(sh, g, z1, z3, ins, seed, name) {
    G = ins + egy_batter; E = egy_z(z3, ins); zt = E[0]; zr = E[1];
    difference() {
        color(egy_sand) hull() { slab(sh, g, z1 - eps, -ins); slab(sh, g, zt, -G); }      // battered walls
        color(egy_lapis) egy_cuts(sh, g, z1, zt, ins, seed, name);
    }
    color(egy_sand) {
        hull() { slab(sh, g, zt - eps, -G); slab(sh, g, zt + 1, -G + 1); }                 // torus roll
        translate([0, 0, zt + 1]) linear_extrude(1) offset(delta = -G + 1) plan(sh, g);
        hull() { slab(sh, g, zt + 2 - eps, -G + 1); slab(sh, g, zr, -G); }
        R = G / (1 - cos(45));                    // cavetto: vertical at the foot, 45 deg at the lip
        for (i = [0:7]) hull() for (q = [i, i + 1]) let(t = 45 * q / 8)
            slab(sh, g, zr + R * sin(t) - (q == i ? eps : 0), -G + R * (1 - cos(t)));
    }
}

// --- flat-face patterns: knurled, quilted, woven, monogram ------------
// Runs children() once per flat face, in face coordinates: x across the face
// as seen from outside, y = height, z = outward normal (z = 0 on the wall).
// $fw = usable face width, $zlo / $zhi = usable height, $face = 0..3.
module on_faces(sh, g, z1, z2, ins, m = 2) {
    hx = g[2] / 2 - ins; hy = g[3] / 2 - ins;
    mx = sh == 1 ? 0.3 * hx : max(corner_r, rim * 1.6) + m;   // corners stay smooth
    my = sh == 1 ? 0.3 * hy : max(corner_r, rim * 1.6) + m;
    for (f = [0:3]) let($face = f, $fw = f < 2 ? 2 * (hx - mx) : 2 * (hy - my), $zlo = z1 + 3, $zhi = z2 - 3)
        if ($zhi - $zlo > 8 && $fw > 8)
            translate(f == 0 ? [0, -hy, 0] : f == 1 ? [0, hy, 0] : f == 2 ? [hx, 0, 0] : [-hx, 0, 0])
                rotate([90, 0, [0, 180, 90, -90][f]]) children();
}

module face_rect() translate([-$fw / 2, $zlo]) square([$fw, $zhi - $zlo]);
module face_engrave(d) translate([0, 0, -d]) linear_extrude(2 * d) children();

// 90 deg V-grooves at +/-45 deg across the panel (knurling, quilting seams).
// On a 45 deg groove every flank stays within 30 deg of vertical: no overhangs.
// half_w > depth gives a wider, softer groove (quilting puff) - flanks only get gentler.
module vgrooves(pitch, depth, half_w = 0) {
    hw = half_w > 0 ? half_w : depth;
    h = $zhi - $zlo; R = sqrt($fw * $fw + h * h) / 2 + pitch; w = hw * sqrt(2);
    intersection() {
        translate([-$fw / 2, $zlo, -depth - 1]) cube([$fw, h, 2 * depth + 2]);
        translate([0, ($zlo + $zhi) / 2, 0]) for (a = [45, -45]) rotate([0, 0, a])
            for (c = [-R:pitch / sqrt(2):R]) translate([0, c, 0]) scale([1, 1, depth / hw]) rotate([45, 0, 0]) cube([2 * R, w, w], center = true);
    }
}

// quilting: a dashed stitch line either side of every seam
module quilt_stitches2d(pitch, off) {
    h = $zhi - $zlo; R = sqrt($fw * $fw + h * h) / 2 + pitch; dl = quilt_stitch;
    intersection() {
        face_rect();
        translate([0, ($zlo + $zhi) / 2]) for (a = [45, -45]) rotate(a)
            for (c = [-R:pitch / sqrt(2):R], s = [-1, 1]) translate([0, c + s * off])
                for (x = [-R:2 * dl:R]) translate([x, 0]) square([dl, 0.8], center = true);
    }
}

// intrecciato-style basket weave, laid on the diagonal
module weave2d(p, w) {
    h = $zhi - $zlo; R = sqrt($fw * $fw + h * h) / 2 + p; n = ceil(R / p);
    intersection() {
        face_rect();
        translate([0, ($zlo + $zhi) / 2]) rotate(45) {
            for (i = [-n:n]) {
                translate([i * p - w / 2, -R]) square([w, 2 * R]);
                translate([-R, i * p - w / 2]) square([2 * R, w]);
            }
            for (i = [-n:n - 1], j = [-n:n - 1])     // each cell holds two strips, alternating direction
                if (abs(i + j) % 2 == 0) translate([i * p, j * p + p / 2 - w / 2]) square([p, w]);
                else translate([i * p + p / 2 - w / 2, j * p]) square([w, p]);
        }
    }
}

// the cells whose strips run "under" (sunk a little to show the over/under)
module weave_under2d(p) {
    h = $zhi - $zlo; R = sqrt($fw * $fw + h * h) / 2 + p; n = ceil(R / p);
    intersection() {
        face_rect();
        translate([0, ($zlo + $zhi) / 2]) rotate(45)
            for (i = [-n:n - 1], j = [-n:n - 1]) if (abs(i + j) % 2 == 1) translate([i * p, j * p]) square(p);
    }
}

// canvas-style repeat: your monogram, a stud and a four-petal flower,
// between running greek-key bands
module mono_motif(k, s, w) {
    if (k == 0) text(mono_text, size = s * 0.42, font = font, halign = "center", valign = "center");
    else if (k == 1) { ring2d(s * 0.22, w); circle(r = s * 0.09, $fn = 20); }
    else difference() {
        union() for (a = [0:90:270]) rotate(a) translate([s * 0.13, 0]) circle(r = s * 0.12, $fn = 20);
        circle(r = s * 0.05, $fn = 12);
    }
}

module greek_key2d(x0, x1, y0, u, w) {
    k = u / 5; n = floor((x1 - x0) / u); xs = x0 + (x1 - x0 - n * u) / 2;
    stroke([x0, y0], [x1, y0], w); stroke([x0, y0 + u], [x1, y0 + u], w);
    for (i = [0:1:n - 1]) let(b = xs + i * u + k / 2)
        strokes([[b, y0], [b, y0 + 4 * k], [b + 4 * k, y0 + 4 * k], [b + 4 * k, y0 + k],
                 [b + 2 * k, y0 + k], [b + 2 * k, y0 + 2.5 * k]], w);
}

module monogram2d() {
    s = mono_size; w = 0.8; kb = mono_key; h = $zhi - $zlo;
    if (h > 2 * kb + s) {
        greek_key2d(-$fw / 2, $fw / 2, $zlo, kb, w);
        greek_key2d(-$fw / 2, $fw / 2, $zhi - kb, kb, w);
    }
    y0 = $zlo + kb + 2.5; y1 = $zhi - kb - 2.5;
    intersection() {
        translate([-$fw / 2, y0]) square([$fw, max(0, y1 - y0)]);
        let(ny = ceil((y1 - y0) / (s * 0.6)) + 1, nx = ceil($fw / s) + 2, yc = (y0 + y1) / 2)
            for (j = [-ny:ny], i = [-nx:nx]) let(x = (i + abs(j % 2) * 0.5) * s, y = yc + j * s * 0.6)
                translate([x, y]) mono_motif(abs(j % 2) == 0 ? 0 : (abs(i % 2) == 0 ? 1 : 2), s, w);
    }
}

// --- container: the body under a removable lid becomes an open-top box.
// Its wall sits inside the deepest surface detail of each style, and never
// reaches out under the lid ridge, so the rim stays solid.
function is_box(Z) = removable_top && container && Z[4] - box_floor > 6;
function box_off(bs, g, Z) = let(ins = Z[0], hy = g[3] / 2 - ins,
    extra = bs == 1 ? flute_r : bs == 2 ? waist : bs == 3 ? 0.8 * ins + 1 :
            bs == 4 ? min(col_r, hy / 3) : bs == 5 ? min(deco_depth, hy / 4) :
            bs == 6 ? knurl_depth : bs == 7 ? checker_depth : bs == 11 ? quilt_depth + 0.8 :
            bs == 12 ? weave_depth : bs == 13 ? mono_depth :
            bs == 8 ? vor_depth : bs == 9 ? 2 * arc_depth : bs == 10 ? egy_batter + egy_depth : 0)
    -max(ins + extra + box_wall, lip_in + lip_w + 1);

module box2d(sh, g, bs, Z) {
    offset(delta = box_off(bs, g, Z)) plan(sh, g);
}

// the style actually built (fancy styles fall back to classic when too short)
function eff_style(bs, g, Hc) = let(Z = body_z(Hc), h = Z[3] - Z[2])
    Z[0] <= 0 || h <= 0 ? 0 :
    (bs == 4 || bs == 5) && h < 26 ? 0 :
    bs == 7 && h < checker_size + 4 ? 0 :
    bs == 8 && h < vor_cell + 8 ? 0 :
    bs == 9 && h < arc_band + 26 ? 0 :
    bs == 10 && egy_z(Z[4], Z[0])[0] - Z[2] < egy_glyph + 16 ? 0 :
    (bs == 6 || bs >= 11) && h < 24 ? 0 : bs;

// foot band, chamfer, shaft, chamfer, cap band - up to height Hc
module pillar_body(sh, bs0, g, Hc, seed, col) {
    Z = body_z(Hc); ins = Z[0]; z0 = Z[1]; z1 = Z[2]; z2 = Z[3]; z3 = Z[4];
    bs = eff_style(bs0, g, Hc);
    tw = bs == 3 ? min(twist, 2 * asin(min(1, 0.8 * ins / (g[2] / 2)))) : 0;
    color(col) {
        hull() { slab(sh, g, 0, -foot_chamfer); slab(sh, g, foot_chamfer); slab(sh, g, z0 - eps); }
        if (ins > 0) {
            hull() { slab(sh, g, z0 - eps); slab(sh, g, z1, -ins, tw / 2); }
            hull() { slab(sh, g, z2, -ins, -tw / 2); slab(sh, g, z3); }
        }
        translate([0, 0, z3]) linear_extrude(cap_t) plan(sh, g);
    }
    if (ins > 0 && z2 > z1) {
        if (bs == 2) color(col) {
            n = 12;
            for (k = [0:n - 1]) hull() for (q = [k, k + 1])
                slab(sh, g, lerp(z1, z2, q / n), -ins - waist * sin(180 * q / n));
        } else if (bs == 3) color(col) {
            translate([0, 0, z1]) rotate(tw / 2)
                linear_extrude(z2 - z1, twist = tw, slices = max(4, round((z2 - z1) / 4)))
                    offset(delta = -ins) plan(sh, g);
        } else if (bs == 4) color(col) colonnade(sh, g, z1, z2, ins);
        else if (bs == 5) color(col) deco(sh, g, z1, z2, ins);
        else if (bs == 10) egyptian(sh, g, z1, z3, ins, seed, seed < len(names) ? names[seed] : "");
        else {
            difference() {
            color(col) translate([0, 0, z1 - eps]) linear_extrude(z2 - z1 + 2 * eps) offset(delta = -ins) plan(sh, g);
            if (bs == 1) color(col) flutes(g, z1, z2, ins);
            if (bs == 7) color(checker_color) checker_cut(sh, g, z1, z2, ins);
            if (bs == 6) color(col) on_faces(sh, g, z1, z2, ins) vgrooves(knurl_pitch, knurl_depth);
            if (bs == 11) {
                color(col) on_faces(sh, g, z1, z2, ins) {
                    vgrooves(quilt_size, quilt_depth, quilt_size * 0.22);   // puffy diamonds
                    vgrooves(quilt_size, quilt_depth + 0.6);                 // tight seam
                }
                color(stitch_color) on_faces(sh, g, z1, z2, ins)
                    face_engrave(quilt_depth + 0.8) quilt_stitches2d(quilt_size, quilt_depth + 2);
            }
            if (bs == 12) color(col * 0.6) on_faces(sh, g, z1, z2, ins) {   // over / under: every other cell sits lower, then the strip grooves
                face_engrave(weave_depth * 0.45) weave_under2d(weave_size);
                face_engrave(weave_depth) weave2d(weave_size, 1.2);
            }
            if (bs == 13) color(gold_color) on_faces(sh, g, z1, z2, ins) face_engrave(mono_depth) monogram2d();
            if (bs == 8) let(cage = is_cage(bs, g, Z))
                color(col) voronoi_cut(sh, g, z1, cage && !removable_top ? min(z2, cav_za(g, Z)) : z2,
                                       ins, seed * 11 + 1, cage);
                if (bs == 9) let(cage = is_cage(bs, g, Z))
                    color(col) arcade_cut(sh, g, z1, cage && !removable_top ? min(z2, cav_za(g, Z)) : z2, ins, cage);
            }
            if (bs == 9) let(cage = is_cage(bs, g, Z))
                color(col) arcade_bands(sh, g, z1, cage && !removable_top ? min(z2, cav_za(g, Z)) : z2, ins);
        }
    }
}

module studs() {
    for (i = [0:fig_studs_x - 1], j = [0:fig_studs_y - 1])
        translate([(i - (fig_studs_x - 1) / 2) * 8, (j - (fig_studs_y - 1) / 2) * 8, -eps]) {
            cylinder(d = stud_d, h = stud_h - 0.3 + eps);
            translate([0, 0, stud_h - 0.3]) cylinder(d1 = stud_d, d2 = stud_d - 0.6, h = 0.3);
        }
}

module pad2d(g) {
    offset(r = 4) square([g[0] - 8, g[1] - 8], center = true);
}

pillar_colors = [[0.93, 0.90, 0.84], [0.78, 0.77, 0.74], [0.30, 0.30, 0.33]];
pad_color  = [0.32, 0.33, 0.36];
checker_color = [0.12, 0.12, 0.13];
stitch_color = [0.88, 0.68, 0.22];
gold_color = [0.80, 0.64, 0.28];
// preview colours: stone for the classical styles, materials for the rest
function style_color(bs, sh) = bs == 10 ? egy_sand : bs == 6 ? [0.58, 0.60, 0.63] :
    bs == 11 ? [0.13, 0.13, 0.14] : bs == 12 ? [0.50, 0.30, 0.16] : bs == 13 ? [0.42, 0.29, 0.18] : pillar_colors[sh];
stud_color = [0.20, 0.55, 0.28];

// the whole pillar as one solid, before it is split into body + top
module pillar_solid(n) {
    p  = P[n]; g = geo_of(n);
    sh = p[6]; H = p[5];
    Hc = fig_step ? H - step_drop : H;
    pa = pad_at(p, g); fs = fig_spots(p, g);
    nm_txt = n < len(names) ? names[n] : "";
    difference() {
        union() {
            pillar_body(sh, body_of(n), g, Hc, n, style_color(eff_style(body_of(n), g, Hc), sh));
            if (fig_step) color(style_color(eff_style(body_of(n), g, Hc), sh)) translate([0, 0, Hc - eps]) linear_extrude(step_drop + eps)
                intersection() { plan(sh, g); translate([-g[2], -g[3] / 2 + fzy]) square([2 * g[2], g[3]]); }
            if (stud_mode == "printed")
                color(stud_color) for (fa = fs) translate(fa) studs();
        }
        if (pad_style != "none") color(pad_color)
            translate([pa[0], pa[1], H - pad_depth]) linear_extrude(pad_depth + 1)
                if (pad_style == "recess") pad2d(g);
                else difference() { pad2d(g); offset(delta = -1.2) pad2d(g); }
        if (stud_mode == "lego_plate") color(stud_color) for (fa = fs)
            translate(fa - [0, 0, 3.2]) linear_extrude(4)
                square([fig_studs_x * 8 - 0.2 + 2 * plate_clear, fig_studs_y * 8 - 0.2 + 2 * plate_clear], center = true);
        if (nm_txt != "") color([0.78, 0.62, 0.25])
            translate([0, -g[3] / 2 + name_depth, Hc - cap_t / 2]) rotate([90, 0, 0])
                linear_extrude(name_depth + 1)
                    text(nm_txt, size = min(name_size, cap_t * 0.6), font = font,
                         halign = "center", valign = "center");
    }
}

// ---------------------------------------------------------------------
//  Removable tops: the pillar splits at the bottom of the cap band. A
//  ridge on the body (vertical sides, pointed 45 deg crest) drops into a
//  matching groove under the top - both print upright, no supports, and
//  the non-round ridge stops the top from turning.
// ---------------------------------------------------------------------
BIG = 1000;
function pillar_z(n) = let(p = P[n]) body_z(fig_step ? p[5] - step_drop : p[5]);

module lip(sh, g, c = 0) {
    o1 = -lip_in + c; o2 = -lip_in - lip_w - c; hh = lip_h + c; ch = (o1 - o2 - 0.4) / 2;
    difference() {
        hull() { slab(sh, g, 0, o1); slab(sh, g, hh - ch, o1); slab(sh, g, hh, o1 - ch); }
        hull() { slab(sh, g, -1, o2); slab(sh, g, hh - ch, o2); slab(sh, g, hh + eps, o2 + ch); }
    }
}

module part_body(n) {
    p = P[n]; g = geo_of(n); sh = p[6]; Z = pillar_z(n);
    bs = eff_style(body_of(n), g, fig_step ? p[5] - step_drop : p[5]);
    cage = is_cage(bs, g, Z);
    difference() {
        if (removable_top) intersection() {
            pillar_solid(n);
            translate([-BIG / 2, -BIG / 2, -1]) cube([BIG, BIG, Z[4] + 1]);
        } else pillar_solid(n);
        if (cage) color(pillar_colors[sh]) cavity(sh, g, Z);
        else if (is_box(Z)) color(pad_color)
            translate([0, 0, box_floor]) linear_extrude(Z[4] - box_floor + 1) box2d(sh, g, bs, Z);
    }
    if (removable_top) color(pillar_colors[sh]) translate([0, 0, Z[4] - eps]) lip(sh, g);
}

module part_top(n) {   // left in place: its underside sits at z = Z[4]
    p = P[n]; g = geo_of(n); sh = p[6]; Z = pillar_z(n);
    difference() {
        intersection() {
            pillar_solid(n);
            translate([-BIG / 2, -BIG / 2, Z[4]]) cube([BIG, BIG, BIG]);
        }
        color(pad_color) translate([0, 0, Z[4] - eps]) lip(sh, g, top_clear);
    }
}

// render() bakes each part into a mesh first; without it the F5 preview's CSG
// tree blows past OpenSCAD's normalization limit and draws nothing
module pillar(n, lift = 0) {
    render() part_body(n);
    if (removable_top) translate([0, 0, lift]) render() part_top(n);
}

// ---------------------------------------------------------------------
//  Ghosts (preview only)
// ---------------------------------------------------------------------
car_colors = [[0.80, 0.08, 0.08], [0.98, 0.78, 0.05], [0.05, 0.30, 0.70], [0.10, 0.55, 0.25],
              [0.95, 0.45, 0.05], [0.95, 0.95, 0.95], [0.15, 0.15, 0.18], [0.55, 0.20, 0.65],
              [0.10, 0.65, 0.75], [0.75, 0.75, 0.78]];
car_len_mix = [1, 0.93, 0.88, 0.97, 0.91];

module ghost_car(cd, l, ci) {
    w = cd[0] - 4; h = cd[2];
    color(car_colors[ci % len(car_colors)]) {
        translate([0, 0, 5]) hull() {
            translate([-l / 2 + 8, -w / 2, 0]) cube([l - 16, w, 12]);
            translate([-l / 2, -w / 2 + 5, 1]) cube([l, w - 10, 8]);
        }
        hull() {
            translate([-l * 0.24, -(w - 12) / 2, 16]) cube([l * 0.46, w - 12, 1]);
            translate([-l * 0.14, -(w - 22) / 2, 16]) cube([l * 0.26, w - 22, h - 24]);
        }
        translate([-l / 2 + 2, -w / 2 + 3, 19]) cube([9, w - 6, 3]);
    }
    color([0.08, 0.08, 0.08]) for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * l * 0.31, sy * (w / 2 - 4), 9]) rotate([90, 0, 0]) cylinder(r = 9, h = 10, center = true, $fn = 24);
}

module ghost_fig(ci) {
    color([0.15, 0.15, 0.18]) {                                    // legs + hips
        for (sx = [-1, 1]) translate([sx * 3.9 - 3.7, -4, 0]) cube([7.4, 8, 11.5]);
        translate([-7.8, -4, 11.5]) cube([15.6, 8, 2]);
    }
    color(car_colors[ci % len(car_colors)]) hull() {               // torso
        translate([-7.8, -4, 13.5]) cube([15.6, 8, eps]);
        translate([-6, -3.5, 25.5]) cube([12, 7, eps]);
    }
    color([0.98, 0.80, 0.10]) translate([0, 0, 25.5]) cylinder(d = 9.6, h = 9);   // head
    color([0.10, 0.10, 0.12]) translate([0, 0, 33]) scale([1.05, 1.05, 0.75]) sphere(d = 11);  // helmet
}

module dressed_pillar(n) {
    p = P[n]; g = geo_of(n); pa = pad_at(p, g);
    pillar(n, top_lift);
    if (show_cars) translate([pa[0], pa[1], p[5]])
        ghost_car(g[4], g[4][1] * car_len_mix[n % len(car_len_mix)], n);
    if (show_figs) for (i = [0:1:len(fig_spots(p, g)) - 1])
        translate(fig_spots(p, g)[i] + [0, 0, stud_h]) ghost_fig(n + 3 * i);
}

// ---------------------------------------------------------------------
//  Output
// ---------------------------------------------------------------------
echo(str("\n==== Speed Champions pillars ====",
    "\n  shelf          ", round(W), " x ", round(D), " mm",
    "\n  layout         ", len(P), " pillars in ", nr, " rows  (spaced for ", round(LtM), " x ", round(WtM), " mm tops)",
    "\n  heights        ", round(front_ok), " .. ", round(max([for (p = P) p[5]])), " mm   rise ",
        round(rise_eff * 10) / 10, "  jitter +/-", round(jit * 10) / 10,
    "\n  tallest + car  ", round(max([for (p = P) p[5]]) + HcarM), " of ", round(HC), " mm clearance",
    "\n  tops           ", removable_top ? str("removable (", cap_t, " mm cap, ridge + groove)", container ? ", bodies hollowed into containers" : "") : "fixed",
    "\n"));
for (n = [0:len(P) - 1]) let(p = P[n], g = geo_of(n))
    echo(str("  pillar ", n, ":  ", g[4][3], "  top ", round(g[2]), " x ", round(g[3]),
             "  row ", p[3], "  h ", round(p[5] * 10) / 10, " mm  ",
             "figs ", figs_of(n), "  ", SH[p[6]], " / ", BS[body_of(n)],
             let(e = eff_style(body_of(n), g, fig_step ? p[5] - step_drop : p[5]))
                 e != body_of(n) ? " (too short - built as classic)" : "",
             n < len(names) ? str("  \"", names[n], "\"") : ""));
for (k = concat([car_size], pillar_sizes))
    if (k != "custom" && search([k], CAR_KEYS)[0] == []) echo(str("WARNING: unknown car size \"", k, "\" - using 8w"));
SIZES_IN_PLAY = concat([car_size], pillar_sizes);
for (i = [0:len(SIZES_IN_PLAY) - 1]) let(k = SIZES_IN_PLAY[i], g = geo(car_dims(k)))
    if (search([k], SIZES_IN_PLAY)[0] == i && g[2] > max(bed_x, bed_y) - 2)
        echo(str("WARNING: ", g[4][3], " pillar is ", round(g[2]), " mm long - at or over the ", max(bed_x, bed_y),
                 " mm bed (print it diagonally, or reduce rim / fig_margin)"));
if (len(pillar_sizes) > len(P)) echo(str("NOTE: ", len(pillar_sizes), " sizes listed but the layout only has ", len(P), " pillars"));
if (rise_eff < rise) echo(str("NOTE: rise reduced from ", rise, " to ", rise_eff, " mm to fit shelf / printer height"));
if (front_ok > front_h) echo(str("NOTE: front_h raised to ", front_ok, " mm (needs foot + cap + ledge + jitter)"));

if (output == "arrangement") {
    %translate([0, 0, -3]) cube([W, D, 3]);
    for (n = [0:len(P) - 1]) let(p = P[n])
        translate([p[0], p[1], 0]) rotate(p[2]) dressed_pillar(n);
} else if (output == "lineup") {
    for (n = [0:len(P) - 1])
        translate([(n % nm) * (LtM + 25), floor(n / nm) * (WtM + 25), 0]) dressed_pillar(n);
} else if (output == "pillar") {
    n = max(0, min(len(P) - 1, pillar_n));
    Z = pillar_z(n);
    if (!removable_top || part == "assembled") pillar(n, top_lift);
    else if (part == "body") render() part_body(n);
    else if (part == "top") translate([0, 0, -Z[4]]) render() part_top(n);
    else {   // print: body and top side by side, both upright
        render() part_body(n);
        translate([0, geo_of(n)[3] + 15, -Z[4]]) render() part_top(n);
    }
}
