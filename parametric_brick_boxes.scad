// =====================================================================
//  Parametric brick boxes
// =====================================================================
//
//  A printable storage box, studded all over, made for building on with
//  real LEGO.
//    - every dimension is LEGO units: footprints in studs (8 mm pitch,
//      0.1 mm play per side), heights in stud rows (8 mm)
//    - each face - top, bottom, front, back, left, right - is studs,
//      sockets (like a brick's underside: a shallow recess with tubes, or pins
//      along a single row, that studs press into) or flat, edge to edge. The walls
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
//  Printing (part = print_in_place, the default, or part = print for two pieces):
//    body  upright as modelled (open top up). Bottom studs land on the bed
//          and need supports; with bottom sockets or flat, no supports
//    lid   upright as modelled (top up, open underside down), its flat bottom
//          edge on the bed (it sits flush on the flat wall top). The top skin
//          over the hollow and the hinge slots need supports; the top studs
//          print upright
//    print_in_place: one piece, the body upright with the lid standing open
//          90 deg on it, nothing to assemble. Gaps of pip_gap separate them:
//          round the hinge (loose, and with no lead-in the pins are captive)
//          and under the lid, where the wall tops it stands on are dropped.
//          The detent bead stands out pip_gap further to make up for the
//          loose pins, and comes to a point so its groove is all 45 deg faces.
//          Only a narrow strip on the edge of the lid's skin is bridged, between
//          solid ends where the wall's seat ridge is cut away.
//          The lid's top studs then print sideways like wall studs
//          (side_stud_d) and the front of its band faces up (stud_d); top
//          sockets take side_socket_d. A lid over 1 row tall overhangs the
//          back and needs supports there
//  Hinge: the body's tabs print upright with flat-bottomed pins. To fit the
//  lid, hold it upright (open 90 deg) behind the tabs and slide it forward
//  onto the pins, then close it. Tune hinge_play for stiffness.
//  Side studs print as short horizontal pegs, with a small flat shaved off
//  the side facing down as printed (side_stud_flat) so the worst of the
//  overhang is gone. Wall sockets print with a flat ceiling over each recess,
//  broken into short bridges by a thin rib between each pair of stud columns;
//  their tubes and pins print as short horizontal pegs.
//  Print stud_fit_test.scad, then a 6 x 5 box, to tune stud_d / side_stud_d /
//  socket_d / side_socket_d / lid_clear.
//  Set row for where the box stands on the shelf, then export with part = print_in_place / print / body / lid.
// =====================================================================

// the label's default font, so it renders the same without installing it
use <fonts/Fredoka.ttf>

/* [Box to print] */
// print_in_place: body and lid as one piece, the lid standing open at 90 deg - nothing to assemble, and the hinge can't come apart. print: body and lid side by side, to assemble
part = "print_in_place"; // [print_in_place, print, body, lid]
// print_in_place: the gap left between body and lid, mm
pip_gap = 0.3;          // [0.2:0.05:0.6]

/* [Box size] */
// box length, left to right, studs (the whole footprint)
studs_l = 22;           // [4:1:40]
// box width, front to back, studs
studs_w = 8;            // [4:1:30]
// stud rows on the sides of a front-row box, the lid band's included - sets the box height
side_rows = 3;          // [2:1:30]
// stud rows on the lid band, out of side_rows (the body keeps at least one)
lid_rows = 1;           // [1:1:10]
// extra stud rows for each row further back
rise = 6;               // [0:1:12]
// shelf row the box is for, 0 = front: each row back is rise stud rows taller, so whatever stands on the boxes in back sits higher
row = 0;                // [0:1:6]
// rounding of the vertical edges, mm (the corner studs start 1.5 mm in)
corner_r = 1;           // [0:0.25:1.5]

/* [Studs] */
// each face, edge to edge: studs, sockets (a recess with tubes that takes studs, like a brick's underside) or flat
top = "studs";          // [studs, sockets, flat]
bottom = "sockets";     // [studs, sockets, flat]
front = "studs";        // [studs, sockets, flat]
back = "sockets";       // [studs, sockets, flat]
left = "flat";          // [studs, sockets, flat]
right = "flat";         // [studs, sockets, flat]
// printed stud diameter - tune for clutch (LEGO 4.8)
stud_d = 4.85;          // [4.6:0.05:5.1]
stud_h = 1.8;           // [1.2:0.1:2]
// wall studs print sideways and size differently - tune separately
side_stud_d = 4.85;     // [4.6:0.05:5.1]
// flat shaved off the underside of wall studs, for a cleaner overhang
side_stud_flat = 0.4;   // [0:0.1:1]
// top and bottom sockets: the gap a stud squeezes into, between recess wall and tube - tune for clutch
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
label = "bricks";
// text height, mm
label_size = 8;         // [3:0.5:30]
// any installed font; Fredoka comes with these files (fonts/)
label_font = "Fredoka:style=Bold";   // font
// lean the letters forward, degrees: italics for any font
label_slant = 10;       // [0:1:30]
// turn the label on the lid top, degrees anticlockwise (0 reads from the front)
label_rotate = 0;       // [0:1:359]
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
BEEF = 2;               // lid: solid margin round the hinge slots and the detent pocket
PIP = part == "print_in_place";
HCLR = PIP ? max(hinge_clear, pip_gap) : hinge_clear;   // gap round the tabs in their slots
// detent bead height: printed in place, the loose pins let the shut lid slide pip_gap
// forward, away from the bead, so the bead stands out that much further
DT_BUMP = detent_bump + (PIP ? pip_gap : 0);
// printed in place the lid stands open, and its front skin is a ceiling over the post:
// there the bead comes to a point and sits at the foot of the post, so the lid's groove
// is all 45 deg faces, running on into the chamfer above it - nothing to bridge
// Below the groove a flat strip DT_LIP wide is left on the skin's edge: standing open, it
// is the first layer there, bridged between the solid ends (see detent_trim/detent_fill)
DT_LIP = PIP ? 0.8 : 0;
DT_V = PIP ? 2 * (DT_BUMP + lid_clear) + DT_LIP : 2.2;   // detent post: the height of its vertical outer face above the seam
DT_Z = PIP ? DT_BUMP + lid_clear + DT_LIP : 1.4;         // detent bead centre above the seam, on the post's outer face
DT_FLAT = PIP ? 0 : 0.6;                        // flat on the bead tip
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
LABEL_UPRIGHT = is_undef(LABEL_TM) ? let(w = len(label) * label_size * 0.7) [[-w / 2, -label_size / 2], [w / 2, label_size / 2]]
                                   : [LABEL_TM.position, LABEL_TM.position + LABEL_TM.size];
LABEL_BOX = let(b = LABEL_UPRIGHT, t = tan(label_slant))   // slanted, the top leans right and the bottom left
    [[b[0][0] + min(t * b[0][1], t * b[1][1]), b[0][1]], [b[1][0] + max(t * b[0][1], t * b[1][1]), b[1][1]]];
// (sockets: a whole stud cell clear of it, so the socket field round it stays whole)
function rot2(a, p) = [p[0] * cos(a) - p[1] * sin(a), p[0] * sin(a) + p[1] * cos(a)];
// the stud position turned back into the label's own frame, so a turned label clears only the studs it covers
function in_label(fs, x, y) = let(r = (top == "sockets" ? PITCH / 2 : stud_d / 2) + LABEL_GAP, p = rot2(-label_rotate, [x, y]))
    LABEL && p[0] > LABEL_BOX[0][0] - r && p[0] < LABEL_BOX[1][0] + r && p[1] > LABEL_BOX[0][1] - r && p[1] < LABEL_BOX[1][1] + r;
// the turned label's footprint on the lid, [width, depth]
LABEL_SPAN = let(b = LABEL_BOX, c = [for (x = [b[0][0], b[1][0]], y = [b[0][1], b[1][1]]) rot2(label_rotate, [x, y])])
    [max([for (q = c) q[0]]) - min([for (q = c) q[0]]), max([for (q = c) q[1]]) - min([for (q = c) q[1]])];
module label2d(fs) rotate(label_rotate) multmatrix([[1, tan(label_slant), 0, 0], [0, 1, 0, 0], [0, 0, 1, 0]]) text(label, size = label_size, font = label_font, halign = "center", valign = "center");

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
// wall stud, with the flat on whichever side ends up pointing down as printed:
// at angle a round its axis from local +x (-90: local -y, for the body and the
// two-piece lid; the lid printed in place sets its own)
module side_stud(a = -90) intersection() {
    stud_shape(side_stud_d);
    rotate(a + 90)
        translate([-side_stud_d, -side_stud_d / 2 + side_stud_flat, -1]) cube([2 * side_stud_d, 2 * side_stud_d, stud_h + 2]);
}
// the lid's studs: printed in place, standing open, its top studs point back
// like wall studs (flat underneath, local +y), and the front of its band
// points up, studs and all
module lid_top_stud() if (PIP) side_stud(90); else stud();

// LEGO-style sockets on a face, like a brick's underside: one shallow
// recess round a grid of stud positions (us x vs, the face's own 2D
// coordinates), each stud gripped between the recess wall and hollow tubes
// standing in it - or, along a single row, small solid pins between the
// studs. A cutter going +z into the face from z = 0, with a chamfered
// mouth: lead-in, and room for first-layer squish.
//   keep: [u0, u1, v0, v1], for each edge its coordinate when the face
//         across that edge has sockets too, else undef. The recess then
//         stays KEEP back from that edge so the corner stays solid, and the
//         edge studs get round holes.
//   skip: stud positions left solid, a whole stud cell each
//   ribs: the face prints upright, +v up: a thin rib the whole height between
//         each pair of stud columns, joining ceiling, tubes (or pins) and floor,
//         so the ceiling and the tubes' undersides print as short bridges
//         instead of one the length of the face
KEEP = SOCKET_H + 0.8;
RIB = 1.2;              // socket ceiling ribs: 3 lines, ~1 mm clear of the studs either side
function mids(a) = [for (i = [0:len(a) - 2]) (a[i] + a[i + 1]) / 2];
function edge_stud(a, i, lo, hi) = (!is_undef(lo) && i == 0) || (!is_undef(hi) && i == len(a) - 1);

module recess2d(us, vs, d, keep, skip) let(r = d / 2, nu = len(us), nv = len(vs),
        u0 = is_undef(keep[0]) ? us[0] - r : max(us[0] - r, keep[0] + KEEP),
        u1 = is_undef(keep[1]) ? us[nu - 1] + r : min(us[nu - 1] + r, keep[1] - KEEP),
        v0 = is_undef(keep[2]) ? vs[0] - r : max(vs[0] - r, keep[2] + KEEP),
        v1 = is_undef(keep[3]) ? vs[nv - 1] + r : min(vs[nv - 1] + r, keep[3] - KEEP))
    difference() {
        union() {
            if (u1 > u0 && v1 > v0) translate([u0, v0]) square([u1 - u0, v1 - v0]);
            for (i = [0:nu - 1], j = [0:nv - 1])
                if (edge_stud(us, i, keep[0], keep[1]) || edge_stud(vs, j, keep[2], keep[3])) translate([us[i], vs[j]]) circle(d = d, $fn = 48);
        }
        for (s = skip) translate(s) square(PITCH, center = true);
    }

// a tube (id > 0) or pin standing in the recess, its tip chamfered
module socket_post(od, id = 0) difference() {
    union() {
        cylinder(d1 = od - 2 * SOCKET_CH, d2 = od, h = SOCKET_CH + eps, $fn = 48);
        translate([0, 0, SOCKET_CH]) cylinder(d = od, h = SOCKET_H, $fn = 48);
    }
    if (id > 0) translate([0, 0, -1]) cylinder(d = id, h = SOCKET_H + 2, $fn = 48);
}

module socket_field(us, vs, d, keep = [undef, undef, undef, undef], skip = [], ribs = false) difference() {
    union() {
        translate([0, 0, -1]) linear_extrude(SOCKET_H + 1) recess2d(us, vs, d, keep, skip);
        for (i = [0:3]) translate([0, 0, i * SOCKET_CH / 4 - (i == 0 ? 1 : 0)])
            linear_extrude(SOCKET_CH / 4 + (i == 0 ? 1 : 0) + eps) offset(delta = SOCKET_CH * (1 - i / 4)) recess2d(us, vs, d, keep, skip);
    }
    // ribs the whole height between each pair of stud columns, floor to ceiling through the tubes (their holes left open) or pins
    if (ribs && len(us) > 1) for (u = mids(us)) difference() {
        translate([u - RIB / 2, vs[0] - d / 2 - 1, -2]) cube([RIB, vs[len(vs) - 1] - vs[0] + d + 2, SOCKET_H + 3]);
        if (len(vs) > 1) for (v = mids(vs)) translate([u, v, -3]) cylinder(d = d, h = SOCKET_H + 5, $fn = 48);
    }
    // tubes touch the 4 studs round them (od + d = the diagonal pitch) and take a stud inside too (id = d); pins touch the 2 either side
    if (len(us) > 1 && len(vs) > 1) for (u = mids(us), v = mids(vs)) translate([u, v, 0]) let(od = PITCH * sqrt(2) - d) socket_post(od, d);
    else if (len(us) > 1) for (u = mids(us)) translate([u, vs[0], 0]) socket_post(PITCH - d);
    else if (len(vs) > 1) for (v = mids(vs)) translate([us[0], v, 0]) socket_post(PITCH - d);
}

// one stud grid over each whole side, body and lid band together: studs
// standing straight off the wall, or a socket field going into it -
// whichever kind the face is set to. Each part takes the rows between z0
// and z1 (the back only above back_z0); any that would straddle the seam
// are left out.
module side_faces(fs, H, z0, z1, kind, back_z0 = -1, lid = false) {
    L = mm(fs[0]); W = mm(fs[1]);
    r = kind == "studs" ? side_stud_d / 2 : side_socket_d / 2;
    dl = detent_len * PITCH + 0.6;
    // [kind, rotation, distance out, width in studs, lowest z, the faces to its left and right as seen from outside]
    faces = [[front, 0, W / 2, fs[0], z0, left, right], [back, 180, W / 2, fs[0], max(z0, back_z0), right, left],
             [right, 90, L / 2, fs[1], z0, front, back], [left, -90, L / 2, fs[1], z0, back, front]];
    for (f = faces) if (f[0] == kind) rotate(f[1]) translate([0, -f[2], 0]) {
        if (kind == "studs") for (q = face_pts(f[3] * PITCH, H)) let(z = H / 2 + q[1])
            if (z - r > f[4] && z + r < z1) translate([q[0], eps, z]) rotate([90, 0, 0])
                if (lid && PIP && f[1] == 0) stud();   // printed in place: pointing up
                else side_stud(!lid || !PIP ? -90 : f[1] == 90 ? 0 : f[1] == -90 ? 180 : 90);   // ... or flat towards the back
        if (kind == "sockets") let(us = cols(f[3]), nz = round(H / PITCH),
                zs = [for (k = [0:nz - 1]) let(z = H / 2 + (k - (nz - 1) / 2) * PITCH) if (z - r > f[4] && z + r < z1) z],
                hw = mm(f[3]) / 2,
                // lid: no sockets in front of the detent pockets, behind the front's bottom row
                skip = lid && f[1] == 0 ? [for (u = us, z = zs) if (z < z0 + PITCH && len([for (x = detent_xs(fs)) if (abs(u - x) < dl / 2 + PITCH / 2) x]) > 0) [u, z]] : [])
            if (len(zs) > 0) rotate([90, 0, 0]) mirror([0, 0, 1])   // face coordinates (u, z), cutting in (+y)
                socket_field(us, zs, lid && PIP && f[1] == 0 ? socket_d : side_socket_d,   // printed in place, the lid front faces up
                    [f[5] == "sockets" ? -hw : undef, f[6] == "sockets" ? hw : undef,
                     !lid && bottom == "sockets" ? 0 : undef, lid && top == "sockets" ? H : undef], skip,
                    !lid || !PIP);   // printed upright (the lid printed in place lies on its back)
    }
}

// ---------------------------------------------------------------------
//  Box: body + lid, split lid_rows stud rows below the top
// ---------------------------------------------------------------------
module plan(fs, ins = 0) let(r = max(corner_r - ins, 0.5))
    offset(r = r) square([mm(fs[0]) - 2 * ins - 2 * r, mm(fs[1]) - 2 * ins - 2 * r], center = true);

module slab(fs, z, ins) translate([0, 0, z]) linear_extrude(eps) plan(fs, ins);

// the plan extruded from z0 to z1, its top perimeter rounded over by corner_r too
module rounded_top(fs, z0, z1) let(r = corner_r, n = 8)
    if (r <= 0) translate([0, 0, z0]) linear_extrude(z1 - z0) plan(fs);
    else hull() {
        translate([0, 0, z0]) linear_extrude(z1 - z0 - r) plan(fs);
        for (i = [1:n]) let(t = 90 * i / n) slab(fs, z1 - r + r * sin(t) - eps, r - r * cos(t));
    }

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
    let(uw = HR - WALL, d = uw + TAB_D, g = PIP ? pip_gap : 0)   // buttress under the part of the stem that overhangs the inside
        if (d > 0) polygon(uw < 0 ? [[-TAB_D, -HR + eps], [0, -HR + eps], [0, -HR - d], [uw, -HR - d]]
                                  : [[-TAB_D, -HR + eps], [0, -HR + eps], [0, -HR - g], [uw, -HR - g], [uw, -HR - d]]);   // flush with the seam behind the axis, where the lid lands at 90 deg (pip_gap below it, printed in place)
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
    L = mm(fs[0]); w = TAB_W / 2 + HCLR; hl = w + PIN_L + max(0.3, PIP ? pip_gap : 0);
    ch = hinge_pin_d - 2 * PIN_FLAT + 0.2;                    // lead-in: lets the flatted pins through only at 90 deg
    along_axis(fs, H, -L / 2 - 1, L / 2 + 1)                  // round the lower back edge about the axis
        if (PIP) difference() { translate([0, -HR - 1]) square([HR + 1, HR + 1]); circle(r = HR, $fn = 96); }
        // two-piece, printed top up: a 45 deg chamfer instead, which prints without supports. It
        // lies inside the same circle, so the edge swings just as clear of the wall top
        else polygon([[0, -HR - 1], [HR + 1, -HR - 1], [HR + 1, 0], [HR, 0], [0, -HR]]);
    for (tx = tab_xs(fs)) {
        along_axis(fs, H, tx - w, tx + w) offset(r = HCLR) {
            // the tab as the lid sees it while turning 0..90 deg: head, its
            // tip swung round to the back, and the stem sweeping down and back
            hull() { tab_head2d(); rotate(90) tab_head2d(); }
            translate([-TAB_D, -HR - 1]) square([HR + 1 + TAB_D, HR + 1]);
        }
        along_axis(fs, H, tx - hl, tx + hl) {
            // printed in place: pip_gap all round, and no lead-in, so the pins stay captive
            circle(d = hinge_pin_d + (PIP ? 2 * pip_gap : hinge_play));
            if (!PIP) translate([-ch / 2, -HR - 1]) square([ch, HR + 1]);
        }
    }
}

// the lid's pose: hinged open by open degrees
module lid_pose(fs, H, open) let(a = hinge_axis(fs, H))
    translate([0, a[0], a[1]]) rotate([-open, 0, 0]) translate([0, -a[0], -a[1]]) children();

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

module detent_bead2d(s) let(b = DT_BUMP + lid_clear, z = s + DT_Z, f = DT_FLAT / 2)
    polygon(f > 0 ? [[DT_U + eps, z - b - f], [DT_U - b, z - f], [DT_U - b, z + f], [DT_U + eps, z + b + f]]
                  : [[DT_U + eps, z - b], [DT_U - b, z], [DT_U + eps, z + b]]);

// body: the ridge in front of the post comes off, then the post and bead go on
module detent_trim(fs, H) let(l = detent_len * PITCH + 0.6, s = H - LID_H)
    for (x = detent_xs(fs)) {
        along_front(fs, x - l / 2, x + l / 2) translate([-1, s]) square([DT_U + 1, SEAT + 1]);
        // printed in place: the whole ridge goes, out to BEEF either side, where the lid's
        // skin comes down solid to anchor the edge of its pocket (the post goes on after)
        if (PIP) let(w = l / 2 + BEEF + lid_clear) along_front(fs, x - w, x + w) translate([-1, s]) square([WALL + 2, SEAT + 1]);
    }

module detent_catches(fs, H) let(l = detent_len * PITCH, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2)
        intersection() { union() { detent_post2d(s); detent_bead2d(s); } translate([-1, s - eps]) square([WALL + 2, LID_H]); }

// lid: solid skin in place of the groove over the post, then the post's pocket and the bead's groove
// (printed in place, BEEF further each side: the solid ends the pocket's edge bridges between)
module detent_fill(fs, H) let(l = PIP ? detent_len * PITCH + 0.6 + 2 * BEEF : detent_len * PITCH, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) translate([0, s]) square([WALL + lid_clear + eps, SEAT + lid_clear + eps]);

module detent_cuts(fs, H) let(l = detent_len * PITCH + 0.6, s = H - LID_H)
    for (x = detent_xs(fs)) along_front(fs, x - l / 2, x + l / 2) {
        offset(delta = lid_clear) detent_pocket2d(s, DT_BUMP + 0.2);
        offset(delta = 0.1) detent_bead2d(s);
    }

// ---------------------------------------------------------------------
//  Lid hollow: everything under the top skin inside the outer lip (the band
//  with the sloped groove edge) is open, except solid blocks round the
//  hinge slots and the detent pockets.
// ---------------------------------------------------------------------
// the solid blocks: half-width round each hinge tab and depth in from the back; half-width
// round each detent and depth in from the front, past the pocket
HB_X = TAB_W / 2 + HCLR + PIN_L + max(0.3, PIP ? pip_gap : 0) + BEEF;
HB_Y = HR + TAB_D + HCLR + BEEF;
DB_X = (detent_len * PITCH + 0.6) / 2 + BEEF;
DB_Y = WALL + lid_clear + DT_BUMP + 0.3 + BEEF;

module lid_hollow(fs, H) let(seam = H - LID_H,
        ins = len([for (s = SIDES) if (s == "sockets") s]) > 0 ? max(WALL - TIP, SOCKET_MIN) : WALL - TIP,   // the top of the groove slope, or room for wall sockets
        hx = HB_X, hy = HB_Y, dx = DB_X, dy = DB_Y)
    difference() {
        translate([0, 0, seam - 1]) linear_extrude(LID_H - LID_TOP + 1) plan(fs, ins);
        // printed in place, standing open, the front skin is on top: carry the groove's
        // 45 deg slope on up to the top skin, so the hollow has no flat ceiling
        if (PIP) let(z0 = seam + SEAT + lid_clear) along_front(fs, -mm(fs[0]), mm(fs[0]))
            polygon([[-1, z0 - eps], [ins, z0 - eps], [ins + H - z0 + 1, H + 1], [-1, H + 1]]);
        for (tx = tab_xs(fs)) translate([tx - hx, mm(fs[1]) / 2 - hy, seam - 2]) cube([2 * hx, hy + 1, LID_H + 2]);
        for (x = detent_xs(fs))
            if (!PIP) translate([x - dx, -mm(fs[1]) / 2 - 1, seam - 2]) cube([2 * dx, dy + 1, LID_H + 2]);
            // printed in place its inner face would be a flat ceiling: slope it 45 deg in to the top skin
            else along_front(fs, x - dx, x + dx) polygon([[-1, seam - 2], [dy, seam - 2], [dy, seam], [dy + LID_H + 1, H + 1], [-1, H + 1]]);
    }

module box_body(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            difference() {
                union() {
                    linear_extrude(seam) plan(fs);
                    // printed in place: a seat ridge (the clasp is built round it), but none where
                    // the lid's back edge swings down past it. Two-piece: a flat wall top the lid
                    // sits flush on, so the lid, printed top up, is flat on the bed
                    if (PIP) front_of(fs, mm(fs[1]) / 2 - 2 * HR - 0.5) ridge(fs, seam - eps, RIM, SEAT);
                }
                translate([0, 0, FLOOR]) linear_extrude(seam + SEAT) plan(fs, WALL);
                detent_trim(fs, H);
                // printed in place: the wall tops the lid stands on when open, lowered by pip_gap
                if (PIP) translate([-mm(fs[0]), mm(fs[1]) / 2 - 2 * HR - 0.5, seam - pip_gap]) cube([2 * mm(fs[0]), 2 * HR + 1, SEAT + pip_gap + 1]);
            }
            side_faces(fs, H, 0, seam, "studs");
            if (bottom == "studs") for (x = cols(fs[0]), y = cols(fs[1])) translate([x, y, eps]) mirror([0, 0, 1]) stud();
            hinge_tabs(fs, H);
            detent_catches(fs, H);
        }
        // last, so nothing inside (the hinge buttresses reach down into the floor) fills them
        side_faces(fs, H, 0, seam, "sockets");
        if (bottom == "sockets") let(L = mm(fs[0]), W = mm(fs[1]))
            socket_field(cols(fs[0]), cols(fs[1]), socket_d,
                [left == "sockets" ? -L / 2 : undef, right == "sockets" ? L / 2 : undef,
                 front == "sockets" ? -W / 2 : undef, back == "sockets" ? W / 2 : undef]);
    }
}

// lid in box coordinates: it sits on the seam, H - LID_H, flush on the flat wall
// top (printed in place, a 45 deg groove in its underside drops over the wall's
// ridge instead); inside that it is hollow. Two-piece, it prints upright.
module box_lid(fs, H) {
    seam = H - LID_H;
    difference() {
        union() {
            difference() {
                rounded_top(fs, seam, H);
                // printed in place, the groove over the ridge; it stops at the axis, behind it the
                // lid is solid over the wall
                if (PIP) front_of(fs, mm(fs[1]) / 2 - HR) ridge(fs, seam - 1, RIM - lid_clear - 1, SEAT + lid_clear + 1);
            }
            detent_fill(fs, H);
        }
        hinge_cuts(fs, H);
        detent_cuts(fs, H);
        lid_hollow(fs, H);
        side_faces(fs, H, seam, H, "sockets", seam + PITCH, true);
        // top socket field, solid wherever it would reach down into a hinge slot, and round the label
        if (top == "sockets") let(a = hinge_axis(fs, H), deep = H - SOCKET_H - 0.4 < a[1] + TAB_R + HCLR,
                                  sx = TAB_W / 2 + HCLR + 0.4 + PITCH / 2, sy = a[0] - TAB_R - HCLR - 0.4 - PITCH / 2,
                                  L = mm(fs[0]), W = mm(fs[1]))
            translate([0, 0, H]) mirror([0, 0, 1])
                socket_field(cols(fs[0]), cols(fs[1]), PIP ? side_socket_d : socket_d,   // printed in place, they face back like wall sockets
                    [left == "sockets" ? -L / 2 : undef, right == "sockets" ? L / 2 : undef,
                     front == "sockets" ? -W / 2 : undef, back == "sockets" && LID_ROWS > 1 ? W / 2 : undef],
                    [for (x = cols(fs[0]), y = cols(fs[1]))
                        if ((deep && y > sy && len([for (tx = tab_xs(fs)) if (abs(x - tx) < sx) tx]) > 0) || in_label(fs, x, y)) [x, y]]);
        if (LABEL && !RAISED && LABEL_D > 0) translate([0, 0, H - LABEL_D]) linear_extrude(LABEL_D + 1) label2d(fs);
    }
    // round the lid band, but not the back of its bottom row, which lands on the wall top at 90 deg
    side_faces(fs, H, seam, H, "studs", seam + PITCH, true);
    if (top == "studs") for (x = cols(fs[0]), y = cols(fs[1])) if (!in_label(fs, x, y)) translate([x, y, H - eps]) lid_top_stud();
    if (LABEL && RAISED && LABEL_D > 0) translate([0, 0, H - eps]) linear_extrude(LABEL_D) label2d(fs);
}

body_color = [0.55, 0.56, 0.58];   // mid gray
lid_color  = [0.78, 0.79, 0.80];   // light gray, so the seam stays easy to see

// ---------------------------------------------------------------------
//  Output
// ---------------------------------------------------------------------
echo(str("\n==== Parametric brick box ====",
    "\n  size     ", FS[0], " x ", FS[1], " studs (", round(mm(FS[0])), " x ", round(mm(FS[1])), " mm), ",
                     BH / PLATE, " plates (", BH, " mm) tall",
    "\n  row      ", row, ": side_rows ", side_rows, row > 0 ? str(" + ", row, " x rise ", rise) : "", " = ", ROWS, " stud rows, the top ", LID_ROWS, " on the lid\n"));
if (max(mm(FS[0]), mm(FS[1])) > max(bed_x, bed_y) || min(mm(FS[0]), mm(FS[1])) > min(bed_x, bed_y) || (bottom == "studs" ? stud_h : 0) + (PIP ? BH - LID_H + mm(FS[1]) + (front == "studs" ? stud_h : 0) : BH + TOP_TIP) > bed_z)
    echo("WARNING: the box is too big for the printer bed");
if (WALL < 3.2) echo(str("NOTE: ", WALL, " mm walls leave a ", SEAT, " mm seat ridge and ", DT_U - lid_clear - DT_BUMP - 0.1, " mm of lid skin over the detent"));
if (WALL < SOCKET_MIN && len([for (s = SIDES) if (s == "sockets") s]) > 0)
    echo(str("WARNING: ", WALL, " mm walls leave only ", WALL - SOCKET_H, " mm behind the wall sockets - use ", SOCKET_MIN, " or more"));
if (FLOOR > floor_t) echo(str("NOTE: floor thickened to ", FLOOR, " mm for the bottom sockets"));
if (LID_TOP > lid_top) echo(str("NOTE: lid top thickened to ", LID_TOP, " mm for the top sockets"));
if (LABEL && (LABEL_SPAN[0] > mm(FS[0]) - 2 * WALL || LABEL_SPAN[1] > mm(FS[1]) - 2 * WALL))
    echo(str("WARNING: the label runs off the lid top - lower label_size or shorten the text"));
if (LABEL && LABEL_D < label_depth) echo(str("NOTE: label engraved ", LABEL_D, " mm deep, to leave 0.4 mm of the ", LID_TOP, " mm lid top under it - raise lid_top for deeper"));
if (PIP && LID_ROWS > 1)
    echo(str("NOTE: printed in place, a lid ", LID_ROWS, " rows tall overhangs the back of the box by ", LID_H - PITCH, " mm - it needs supports there"));
if (PIP && FS[1] > 5)
    echo(str("WARNING: printed in place, the open lid stands ", FS[1], " studs tall - over 5, it can wobble or knock the box loose; print it in two pieces (part = print)"));
if (tab_xs(FS)[1] < TAB_W / 2 + HCLR + PIN_L + 2)
    echo(str("WARNING: the box is too short for hinge tabs ", hinge_from_end, " studs from each end - lower hinge_from_end"));
if (let(l = detent_len * PITCH + 0.6, xs = detent_xs(FS))   // each detent inside the end walls, and two clear of each other
        detent_count > 0 && (abs(xs[0]) + l / 2 > mm(FS[0]) / 2 - WALL || (detent_count == 2 && xs[1] - l / 2 < 0)))
    echo(str("WARNING: ", detent_count, " detent", detent_count == 2 ? "s" : "", " ", detent_len, " studs long don't fit along the front - lower detent_len or detent_count"));

BODY_TIP = bottom == "studs" ? stud_h - eps : 0;   // body printed upright: its bottom studs reach the bed
module body_print() translate([0, 0, BODY_TIP]) render() box_body(FS, BH);
module lid_print() translate([0, 0, LID_H - BH]) render() box_lid(FS, BH);   // upright, its seam on the bed
if (part == "body") color(body_color) body_print();
else if (part == "lid") color(lid_color) lid_print();
else if (PIP) translate([0, 0, BODY_TIP]) {   // print in place: body upright, the lid standing open on it
    color(body_color) render() box_body(FS, BH);
    color(lid_color) lid_pose(FS, BH, 90) render() box_lid(FS, BH);
}
else {   // print: body and lid upright, side by side
    color(body_color) body_print();
    color(lid_color) translate([0, mm(FS[1]) + 15, 0]) lid_print();
}
