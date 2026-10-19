// =====================================================================
//  Bridge test
// =====================================================================
//
//  One print finds how far your filament bridges cleanly: a row of strips,
//  each a lid-top-thick skin bridged between two posts, one span per strip,
//  printed as modelled (base flat on the bed, no supports). Each span is
//  engraved on its left pad. Look at the underside of each bridge: the longest
//  one that is flat and solid, not sagging or stringy, is your limit. A
//  two-piece lid's top skin bridges the box width less its walls (about 57 mm
//  at 8 studs), so wider lids need supports; set LID_BRIDGE in
//  tools/build_3mf.sh to the widest box (in studs) whose lid stays inside it.
//  Use the same filament and slicer settings you'll print the boxes with.
// =====================================================================

// bridge spans to test, mm
spans = [20, 25, 30, 35, 40, 45, 50, 55, 60];
// skin thickness (match lid_top in the box file)
skin = 1.6;             // [1.2:0.4:4]
// how high the bridges stand over the base
gap = 6;                // [3:1:20]
// engraved labels
font = "Liberation Sans:style=Bold";

/* [Hidden] */
W = 8;                  // strip width, one stud
POST = 3.2;             // right post: one wall thick
PAD = 10;               // left post, wide enough for the label
BASE = 0.8;             // base strip under each bridge
STEP = W + 3;           // strip pitch
eps = 0.01;

for (i = [0:len(spans) - 1]) let(s = spans[i], l = PAD + s + POST) translate([0, i * STEP, 0]) {
    cube([l, W, BASE]);
    difference() {
        union() {
            cube([PAD, W, BASE + gap]);
            translate([PAD + s, 0, 0]) cube([POST, W, BASE + gap]);
            translate([0, 0, BASE + gap - eps]) cube([l, W, skin + eps]);
        }
        translate([PAD / 2, W / 2, BASE + gap + skin - 0.6]) linear_extrude(1)
            text(str(s), size = 4.5, font = font, halign = "center", valign = "center");
    }
}
