# Parametric brick boxes

Printable, parametric storage boxes, LEGO-compatible and written in OpenSCAD:
studded edge to edge on every side and on the lid (each face can be studs, sockets
or flat), with storage inside.

![A 21 x 12 stud box with its hinged lid open](images/open.png)

| Closed | Studs only front and back |
|---|---|
| ![Closed box, studded on every face](images/closed.png) | ![Box with a plain lid top and plain ends, studs only on the front and back](images/faces.png) |
| **Print layout** | **Rows 0, 1 and 2** |
| ![Body upright, lid inverted beside it](images/print.png) | ![Three boxes stepping up from front to back](images/lineup.png) |

- Everything is in LEGO units: footprints in studs (8 mm), heights in stud rows (8 mm).
- Box size is set directly in studs (`studs_l` x `studs_w`).
- Every box is whole stud rows tall, with studs round the lid band too, so the side
  studs of neighbouring boxes line up. `side_rows` sets the height and `lid_rows` how
  many of those rows are lid. A lid taller than one row swings out behind the box by
  8 mm per extra row when it's open.
- Every face (`top`, `bottom`, `front`, `back`, `left`, `right`) is set to `studs`,
  `sockets` or `flat` in the Customizer's **Studs** group. Sockets are built like a
  LEGO brick's underside: a shallow recess with hollow tubes between each group of four
  studs (small pins along a face only one stud wide), so a box presses onto a baseplate
  or onto another box's studs without a thick solid plate under it. Flat faces take
  a label, or stand flush against a wall or another box.
- Optional text label on the lid top (**Lid label** group): set `label`, and it's
  centred on the lid with the top studs or sockets round it left out. The text is
  engraved into the top skin (prints without supports) or raised off it (`label_style`),
  in any installed font (`label_font`), and can lean into italics (`label_slant`).
- Set `row` for where the box will stand (0 = front): each row back is taller, so
  whatever stands on the boxes in back sits higher.
- Hinged lid on two pinned tabs at the back: friction holds it at any angle up to 90°,
  and it lifts off at 90°.
- Hollow lid: a thin top skin (`lid_top`, thickened automatically under top sockets) over
  an open underside, inside the outer lip, with solid blocks only round the hinge slots
  and the detent.
- Snaps shut on a detent: a bead on the front wall top clicks into the lid; squeeze the
  middle of the box front to release it (`detent_count`, `detent_len`; `detent_bump` sets
  how firm the snap is).
- The body prints upright and the lid inverted (top down). A part standing on studs
  (bottom studs for the body, top studs for the lid) needs supports. With `sockets` or
  `flat` there, it prints flat without supports. Print `stud_fit_test.scad` first to
  find your stud and socket sizes, then a small 6 x 5 box to check the whole fit.
  Or pick `part = print_in_place` to print it all as one piece, with the lid standing open
  on the body: no assembly, at the cost of a loose hinge in place of the friction one
  (`pip_gap` sets the clearance between the parts).
  For reference, on the author's Bambu Lab A1 printing
  [SUNLU PLA 2.0+](https://www.breckenridge.dev/amazon.html?asin=B0FG7VTXTY) (affiliate link), these clutch
  well: `stud_d` (top studs) 5.05, `side_stud_d` (side studs) 4.95–5.00,
  `socket_d` (top and bottom sockets) 4.95 and `side_socket_d` (side sockets)
  4.85–4.95.
- `3mf/` has ready-to-print Bambu Studio projects for the A1 (0.4 mm nozzle, SUNLU PLA+
  2.0, 0.20mm Standard, textured PEI plate) at 6 x 5, 8 x 8, 16 x 8 and 22 x 8 studs,
  3 rows tall, with the default faces (studs on the top and front, sockets on the
  bottom and back, flat sides). Each size comes two-piece (`brick_box_<size>.3mf`, supports on for the
  lid's studs) and in one piece (`brick_box_<size>_print_in_place.3mf`). They use
  `stud_d` 5.05, `side_stud_d` 5.00, `socket_d` 4.95 and `side_socket_d` 4.90; on
  another printer or filament, print the fit test and make your own.

## Use

Open `parametric_brick_boxes.scad` in OpenSCAD (a recent nightly with the
Manifold backend renders much faster) and use the Customizer. Set the size and `row`,
pick `part = print / print_in_place / body / lid / assembled`, then render and export.

`archive/` holds an earlier, decorative pillar version.

## License

© 2026 Aaron Breckenridge. Licensed under
[Creative Commons Attribution-ShareAlike 4.0 International](https://creativecommons.org/licenses/by-sa/4.0/)
(CC BY-SA 4.0); see [LICENSE](LICENSE).

The label's default font, [Fredoka](https://fonts.google.com/specimen/Fredoka)
(`fonts/Fredoka.ttf`), is © The Fredoka Project Authors, under the
[SIL Open Font License 1.1](fonts/OFL.txt).

LEGO® is a trademark of the LEGO Group, which does not sponsor, authorize or endorse
this project.

As an Amazon Associate I earn from qualifying purchases made through the product links
above.
