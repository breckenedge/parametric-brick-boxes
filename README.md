# Parametric Speed Champions display boxes

Printable, parametric display boxes for LEGO Speed Champions (and similar) cars,
written in OpenSCAD. One box per car: studded edge to edge on every side and on the
lid, with storage inside.

- Everything is in LEGO units: footprints in studs (8 mm), heights in stud rows (8 mm).
- Box size is set directly in studs (`studs_l` x `studs_w`), and nothing else changes it; the
  file header lists sizes that suit 6-wide, 8-wide, F1 and other cars.
- Every box is whole stud rows tall, with a row of studs round the lid band too, so the
  side studs of neighbouring boxes line up.
- Set `row` for where the box will stand (0 = front): each row back is taller, so
  the cars in back sit higher.
- Minifig stand space beside each car (0-2 figures, placed by compass direction: N, NE, E, SE, S, SW, W or NW).
- Hinged lid on two pinned tabs at the back: friction holds it at any angle up to 90°,
  and it lifts off at 90°.
- Snaps shut on a detent: a bead on the front wall top clicks into the lid; squeeze the
  middle of the box front to release it (`detent_count`, `detent_len`; `detent_bump` sets
  how firm the snap is).
- Prints without supports. Print `stud_fit_test.scad` first to find your stud sizes, then
  a small 6 x 5 box to check the whole fit.
  For reference, in PLA+ on the author's printer, `stud_d = 5.05` (top) and
  `side_stud_d = 5.00` (sides) clutch well.

## Use

Open `speed_champions_brick_boxes.scad` in OpenSCAD (a recent nightly with the
Manifold backend renders much faster) and use the Customizer. Set the size and `row`,
pick `part = print / body / lid / assembled`, then render and export.

`archive/` holds an earlier, decorative pillar version.

## License

© 2026 Aaron Breckenridge. Licensed under
[Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/)
(CC BY-SA 4.0); see [LICENSE](LICENSE).

LEGO® is a trademark of the LEGO Group, and Hot Wheels® and Mattel Brick Shop™ are
trademarks of Mattel, none of which sponsor, authorize or endorse this project.
