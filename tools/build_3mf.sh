#!/usr/bin/env bash
# Builds ready-to-print Bambu Studio projects (.3mf) for the A1 from parametric_brick_boxes.scad.
# Windows, Git Bash. Needs OpenSCAD (a nightly, for --backend=manifold), Bambu Studio, and
# Bambu Studio's system presets, which it downloads into %APPDATA%\BambuStudio\system on first run.
#
#   tools/build_3mf.sh [out dir] [sizes...]
#   tools/build_3mf.sh out 6x5 8x8x4
#
# Sizes are <studs_l>x<studs_w>, or <studs_l>x<studs_w>x<side_rows> to set the height
# (otherwise the scad's default). Boxes up to 5 studs wide come out printed in place
# (brick_box_<size>_print_in_place.3mf); wider ones in two pieces (brick_box_<size>.3mf),
# since a tall open lid knocks the box loose (see the README). Set MODE=pip or MODE=two to
# force one. No supports, except under two-piece lids over 5 studs wide (LID_SUPPORTS,
# LID_BRIDGE); set SUPPORTS=1 for tree supports on the bed everywhere (bottom studs need them).
# A 5 mm outer brim for grip: BRIM=<width> changes it, BRIM=0 turns it off.
# Takes a few minutes a box. Override any path or the stud sizes with the variables below.
set -euo pipefail

HERE=$(cd "$(dirname "$0")" && pwd)
SCAD="$HERE/../parametric_brick_boxes.scad"
OUT=${1:-3mf}; shift || true
SIZES=("${@:-6x5}")
MODE=${MODE:-auto}

OPENSCAD=${OPENSCAD:-"/c/Program Files/OpenSCAD (Nightly)/openscad.com"}
BAMBU=${BAMBU:-"/c/Program Files/Bambu Studio/bambu-studio.exe"}
PRESETS=${PRESETS:-"$APPDATA/BambuStudio/system/BBL"}
MACHINE=${MACHINE:-"Bambu Lab A1 0.4 nozzle"}
PROCESS=${PROCESS:-"0.20mm Standard @BBL A1"}
FILAMENT=${FILAMENT:-"SUNLU PLA+ 2.0 @BBL A1"}
BED=${BED:-"Textured PEI Plate"}
SUPPORTS=${SUPPORTS:-0}
# two-piece lids wider than LID_BRIDGE studs get tree supports of their own under the bridged
# top skin (a 4-wide lid bridged fine without); the body never does. LID_SUPPORTS=0 for none
LID_SUPPORTS=${LID_SUPPORTS:-1}
LID_BRIDGE=${LID_BRIDGE:-5}
# LID_INVERTED=1 prints two-piece lids top down (lid_inverted): no bridge, so no lid supports
LID_INVERTED=${LID_INVERTED:-0}
# outer brim width, mm (0 for none): with bottom sockets the body only meets the bed with a thin rim
BRIM=${BRIM:-5}
# the author's fit-test results on the A1 with SUNLU PLA+ 2.0 (README)
STUDS=${STUDS:-"-D stud_d=5.05 -D side_stud_d=5.00 -D socket_d=4.95 -D side_socket_d=4.90"}

mkdir -p "$OUT"
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
w() { cygpath -w "$1"; }

# Bambu Studio's CLI ignores a preset's "inherits", so flatten each one first
# (otherwise it falls back to a 200 mm bed and default filament settings)
if [ "$SUPPORTS" = 1 ]; then sup='"enable_support": "1", "support_type": "tree(auto)", "support_on_build_plate_only": "1"'
else sup='"enable_support": "0"'; fi
if [ "$BRIM" = 0 ]; then brim='"brim_type": "no_brim"'
else brim="\"brim_type\": \"outer_only\", \"brim_width\": \"$BRIM\", \"brim_object_gap\": \"0.1\""; fi
echo "{$sup, $brim, \"curr_bed_type\": \"$BED\"}" > "$WORK/ov.json"
resolve() { powershell -NoProfile -ExecutionPolicy Bypass -File "$(w "$HERE/resolve.ps1")" "$(w "$PRESETS")" "$1" "$(w "$2")" ${3:+"$(w "$3")"}; }
resolve "$MACHINE" "$WORK/machine.json"
resolve "$PROCESS" "$WORK/process.json" "$WORK/ov.json"
resolve "$FILAMENT" "$WORK/filament.json"

stl() { # size part file
    local l wd h inv=false; IFS=x read -r l wd h <<< "$1"; [ "$LID_INVERTED" = 1 ] && inv=true
    "$OPENSCAD" --backend=manifold $STUDS -D studs_l=$l -D studs_w=$wd ${h:+-D side_rows=$h} -D lid_inverted=$inv -D "part=\"$2\"" -o "$3" "$SCAD" 2>&1 | grep -E 'WARNING|ERROR' || true
}
project() { # 3mf supported-object stl...
    local out=$1 sobj=$2; shift 2
    local stls=(); for s in "$@"; do stls+=("$(w "$s")"); done
    "$BAMBU" --arrange 1 --orient 0 --load-settings "$(w "$WORK/machine.json");$(w "$WORK/process.json")" \
        --load-filaments "$(w "$WORK/filament.json")" --export-3mf "$(w "$out")" "${stls[@]}"
    [ -s "$out" ] || { echo "failed: $out" >&2; exit 1; }
    powershell -NoProfile -ExecutionPolicy Bypass -File "$(w "$HERE/mark_changed.ps1")" "$(w "$out")" "$(w "$WORK/ov.json")" ${sobj:+"$sobj"}
    echo "built $out"
}

for sz in "${SIZES[@]}"; do
    mode=$MODE
    IFS=x read -r _ wd _ <<< "$sz"
    [ "$mode" = auto ] && { [ "$wd" -le 5 ] && mode=pip || mode=two; }
    if [ "$mode" = pip ]; then
        stl "$sz" print_in_place "$WORK/brick box $sz print in place.stl"
        project "$OUT/brick_box_${sz}_print_in_place.3mf" "" "$WORK/brick box $sz print in place.stl"
    else
        stl "$sz" body "$WORK/brick box $sz body.stl"
        stl "$sz" lid "$WORK/brick box $sz lid.stl"
        sobj=""; [ "$LID_SUPPORTS" = 1 ] && [ "$LID_INVERTED" != 1 ] && [ "$wd" -gt "$LID_BRIDGE" ] && sobj="$sz lid.stl"
        project "$OUT/brick_box_${sz}.3mf" "$sobj" "$WORK/brick box $sz body.stl" "$WORK/brick box $sz lid.stl"
    fi
done
