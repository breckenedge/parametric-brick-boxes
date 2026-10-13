# Parametric Speed Champions display boxes

Printable, parametric display boxes for LEGO Speed Champions (and similar) cars,
written in OpenSCAD. One box per car: round-cornered, with a studded lid, recessed
studded panels on all four sides, and storage inside.

- Everything is in LEGO units: footprints in studs (8 mm), heights in plates (3.2 mm).
- Car size classes: 6-wide, 8-wide, 8-wide long, F1 2020-24, F1 2025+, F1 collectible
  minis (71049), Mattel Brick Shop Speed Series, or custom.
- Boxes are packed onto your shelf in rows, each row taller than the one in front, so
  the cars in back sit higher.
- Minifig stand space beside each car (0-2 figures, placed by compass direction: N, NE, E, SE, S, SW, W or NW).
- Hinged lid on two pinned tabs at the back: friction holds it at any angle up to 90°,
  and it lifts off at 90°. Or set `lid_style = "seat"` for a plain lift-off lid.
- Snaps shut on a detent: a bead inside the front lip clicks into a groove in the lid
  (`detent_count`, `detent_len`; `detent_bump` sets how firm the snap is).
- Prints without supports. Print `stud_fit_test.scad` first to find your stud sizes, then
  `car_size = "coupon"` to check the whole fit.

## Use

Open `speed_champions_brick_boxes.scad` in OpenSCAD (a recent nightly with the
Manifold backend renders much faster) and use the Customizer. The console lists
every box with its size, height and shelf row. Pick one with `box_n`, choose
`part = print / body / lid / assembled`, then render and export.

`archive/` holds an earlier, decorative pillar version.

## License

© 2026 Aaron Breckenridge. Licensed under
[Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/)
(CC BY-SA 4.0); see [LICENSE](LICENSE).

LEGO® is a trademark of the LEGO Group, and Hot Wheels® and Mattel Brick Shop™ are
trademarks of Mattel, none of which sponsor, authorize or endorse this project.
