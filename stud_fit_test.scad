// =====================================================================
//  Stud fit test
// =====================================================================
//
//  One print finds the stud and socket sizes for parametric_brick_boxes.scad.
//  An L-shaped strip, printed as modelled (base flat on the bed):
//    - top: a 2 x 2 group of upright studs per diameter, like the lid
//    - underside: a 2 x 2 socket group per diameter (a recess with a tube,
//      like a brick's underside) and a 1 x 2 group with a pin beside it,
//      open on the bed like the box's top and
//      bottom sockets
//    - back wall: a 2 x 2 group of sideways studs per diameter on its back
//      face, printed the same way as the box walls (flat underside included),
//      and in its front face a 2 x 2 socket group and, above it, a 1 x 2
//      group with a pin, like the wall sockets (a 1-row lid band gets pins)
//  Each group has its diameter engraved beside it (the underside's mirrored,
//  to read with the strip flipped over front to back). Press a real 2 x 2
//  plate onto each stud group and into each socket group (or the studs you
//  mean to use them with): pick the sizes that clutch like LEGO, then set
//  stud_d, side_stud_d, socket_d and side_socket_d in the box file to match.
//  Use the same filament and slicer settings you'll print the boxes with.
// =====================================================================

// diameters to test, mm
sizes = [4.85, 4.90, 4.95, 5.00, 5.05, 5.10];
stud_h = 1.8;           // [1.2:0.1:2]
// flat shaved off the underside of the sideways studs (match the box file)
side_stud_flat = 0.4;   // [0:0.1:1]
// engraved labels
font = "Liberation Sans:style=Bold";

/* [Hidden] */
PITCH = 8;
T = 3.2;                // base and wall thickness: one plate
GROUP = 3 * PITCH;      // a 2-stud group plus a stud's gap
M = 10;                 // margin at each end: room for the first underside 1 x 2 group
N = len(sizes);
L = N * GROUP - PITCH + 2 * M;
LABEL = 9;              // label strip in front of the top studs
WALL_Y = LABEL + 2 * PITCH + 0.5;   // wall just behind where a 2 x 2 plate on the top studs ends
BASE_D = WALL_Y + T;
GROUP_Z = T + 4 + PITCH;        // centre height of the wall's 2 x 2 groups
ROW_Z = GROUP_Z + 1.5 * PITCH;  // ... and of the 1 x 2 socket groups, a row above them on the front
WALL_H = ROW_Z + PITCH / 2 + 8; // room above for the labels
WALL_LABEL_Z = WALL_H - 4;
eps = 0.01;

function gx(i) = M + PITCH / 2 + i * GROUP;      // x of the first stud in group i
module label(i) text(fmt(sizes[i]), size = 4, font = font, halign = "center", valign = "center");
function fmt(v) =let(c = round(v * 100)) str(floor(c / 100), ".", c % 100 < 10 ? "0" : "", c % 100);   // 4.9 -> "4.90"

// same profile as the box file: 0.3 mm chamfer on the tip
module stud_shape(d) {
    cylinder(d = d, h = stud_h - 0.3 + eps, $fn = 48);
    translate([0, 0, stud_h - 0.3]) cylinder(d1 = d, d2 = d - 0.6, h = 0.3, $fn = 48);
}
// local -y ends up pointing down, so that is where the flat goes
module side_stud(d) intersection() {
    stud_shape(d);
    translate([-d, -d / 2 + side_stud_flat, -1]) cube([2 * d, 2 * d, stud_h + 2]);
}

// same sockets as the box file, for a 2 x 2 group centred on the origin: a
// recess round the four studs with a hollow tube in the middle touching all
// four, going +z from z = 0, chamfered mouth
SOCKET_H = stud_h + 0.2;
SOCKET_CH = 0.4;
// rows = 1: a 1 x 2 group instead, with a solid pin between the two studs
// touching both, like the box's single-row sockets (a 1-row lid band)
module socket_group(d, rows = 2) let(w = [PITCH + d, rows == 1 ? d : PITCH + d], od = rows == 1 ? PITCH - d : PITCH * sqrt(2) - d)
    difference() {
        union() {
            translate([0, 0, -1]) linear_extrude(SOCKET_H + 1) square(w, center = true);
            for (i = [0:3]) translate([0, 0, i * SOCKET_CH / 4 - (i == 0 ? 1 : 0)])
                linear_extrude(SOCKET_CH / 4 + (i == 0 ? 1 : 0) + eps) square(w + 2 * SOCKET_CH * (1 - i / 4) * [1, 1], center = true);
        }
        difference() {
            union() {
                cylinder(d1 = od - 2 * SOCKET_CH, d2 = od, h = SOCKET_CH + eps, $fn = 48);
                translate([0, 0, SOCKET_CH]) cylinder(d = od, h = SOCKET_H, $fn = 48);
            }
            if (rows > 1) translate([0, 0, -1]) cylinder(d = od - 1.6, h = SOCKET_H + 2, $fn = 48);
        }
    }

difference() {
    union() {
        cube([L, BASE_D, T]);
        translate([0, WALL_Y, 0]) cube([L, T, WALL_H]);
    }
    for (i = [0:N - 1]) let(x = gx(i) + PITCH / 2) {
        // labels, 0.6 mm deep, one by every group: top (in front of the top studs),
        // underside (mirrored, to read with the strip flipped front to back),
        // and above the groups on both faces of the wall
        translate([x, LABEL / 2, T - 0.6]) linear_extrude(1) label(i);
        translate([x - PITCH * 3 / 4, LABEL / 2, -1]) linear_extrude(1.6) mirror([0, 1, 0]) label(i);   // under both underside groups
        translate([x, WALL_Y + 0.6, WALL_LABEL_Z]) rotate([90, 0, 0]) linear_extrude(1) label(i);
        translate([x, WALL_Y + T - 0.6, WALL_LABEL_Z]) rotate([90, 0, 180]) linear_extrude(1) label(i);
        // underside: a 2 x 2 socket group under the top studs
        translate([x, LABEL + PITCH, 0]) socket_group(sizes[i]);
        // ... and a 1 x 2 group with a pin, running front to back in the gap to its left
        translate([x - 1.5 * PITCH, LABEL + PITCH, 0]) rotate(90) socket_group(sizes[i], 1);
        // wall front face: a 2 x 2 socket group going in (+y) behind the side studs
        translate([x, WALL_Y, GROUP_Z]) rotate([90, 0, 0]) mirror([0, 0, 1]) socket_group(sizes[i]);
        // ... and a 1 x 2 group above it, with a pin
        translate([x, WALL_Y, ROW_Z]) rotate([90, 0, 0]) mirror([0, 0, 1]) socket_group(sizes[i], 1);
    }
}
for (i = [0:N - 1], a = [0, 1], b = [0, 1]) {
    // top: 2 x 2 upright
    translate([gx(i) + a * PITCH, LABEL + PITCH / 2 + b * PITCH, T - eps]) stud_shape(sizes[i]);
    // back wall: 2 x 2 sideways, pointing back (+y)
    translate([gx(i) + a * PITCH, WALL_Y + T - eps, GROUP_Z - PITCH / 2 + b * PITCH])
        rotate([-90, 0, 0]) rotate([0, 0, 180]) side_stud(sizes[i]);   // flat ends up underneath
}
 