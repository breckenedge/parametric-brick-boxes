// =====================================================================
//  Stud fit test
// =====================================================================
//
//  One print finds the stud sizes for speed_champions_brick_boxes.scad.
//  An L-shaped strip, printed as modelled (base flat on the bed):
//    - top: a 2 x 2 group of upright studs per diameter, like the lid
//    - back wall: a 2 x 2 group of sideways studs per diameter, printed
//      the same way as the box walls (flat underside included)
//  Each diameter is engraved in front of its groups. Press a real 2 x 2
//  plate onto each group: pick the size that clutches like LEGO, then set
//  stud_d (top) and side_stud_d (sides) in the box file to match.
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
M = 6;                  // margin at each end
N = len(sizes);
L = N * GROUP - PITCH + 2 * M;
LABEL = 9;              // label strip in front of the top studs
WALL_Y = LABEL + 2 * PITCH + 0.5;   // wall just behind where a 2 x 2 plate on the top studs ends
BASE_D = WALL_Y + T;
WALL_H = T + 2 * PITCH + 6;
eps = 0.01;

function gx(i) = M + PITCH / 2 + i * GROUP;      // x of the first stud in group i
function fmt(v) = let(c = round(v * 100)) str(floor(c / 100), ".", c % 100 < 10 ? "0" : "", c % 100);   // 4.9 -> "4.90"

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

difference() {
    union() {
        cube([L, BASE_D, T]);
        translate([0, WALL_Y, 0]) cube([L, T, WALL_H]);
    }
    for (i = [0:N - 1])
        translate([gx(i) + PITCH / 2, LABEL / 2, T - 0.6])
            linear_extrude(1) text(fmt(sizes[i]), size = 4, font = font, halign = "center", valign = "center");
}
for (i = [0:N - 1], a = [0, 1], b = [0, 1]) {
    // top: 2 x 2 upright
    translate([gx(i) + a * PITCH, LABEL + PITCH / 2 + b * PITCH, T - eps]) stud_shape(sizes[i]);
    // back wall: 2 x 2 sideways, pointing back (+y)
    translate([gx(i) + a * PITCH, WALL_Y + T - eps, T + 4 + PITCH / 2 + b * PITCH])
        rotate([-90, 0, 0]) rotate([0, 0, 180]) side_stud(sizes[i]);   // flat ends up underneath
}
 