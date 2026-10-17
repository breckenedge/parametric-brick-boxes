#!/usr/bin/env bash
# Builds ready-to-print Bambu Studio projects (.3mf) for the A1 from parametric_brick_boxes.scad.
# Windows, Git Bash. Needs OpenSCAD (a nightly, for --backend=manifold), Bambu Studio, and
# Bambu Studio's system presets, which it downloads into %APPDATA%\BambuStudio\system on first run.
#
#   tools/build_3mf.sh [out dir] [sizes...]
#   tools/build_3mf.sh out 6x5 8x8
#
# Sizes are <studs_l>x<studs_w>. Boxes up to 5 studs wide come out printed in place
# (brick_box_<size>_print_in_place.3mf); wider ones in two pieces (brick_box_<size>.3mf),
# since a tall open lid knocks the box loose (see the README). Set MODE=pip or MODE=two to
# force one. No supports: set SUPPORTS=1 for tree supports on the bed (bottom studs need them).
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
# the author's fit-test results on the A1 with SUNLU PLA+ 2.0 (README)
STUDS=${STUDS:-"-D stud_d=5.05 -D side_stud_d=5.00 -D socket_d=4.95 -D side_socket_d=4.90"}

mkdir -p "$OUT"
WORK=$(mktemp -d); trap 'rm -rf "$WORK"' EXIT
w() { cygpath -w "$1"; }

# Bambu Studio's CLI ignores a preset's "inherits", so flatten each one first
# (otherwise it falls back to a 200 mm bed and default filament settings)
if [ "$SUPPORTS" = 1 ]; then
    echo "{\"enable_support\": \"1\", \"support_type\": \"tree(auto)\", \"support_on_build_plate_only\": \"1\", \"curr_bed_type\": \"$BED\"}" > "$WORK/ov.json"
else
    echo "{\"enable_support\": \"0\", \"curr_bed_type\": \"$BED\"}" > "$WORK/ov.json"
fi
resolve() { powershell -NoProfile -ExecutionPolicy Bypass -File "$(w "$HERE/resolve.ps1")" "$(w "$PRESETS")" "$1" "$(w "$2")" ${3:+"$(w "$3")"}; }
resolve "$MACHINE" "$WORK/machine.json"
resolve "$PROCESS" "$WORK/process.json" "$WORK/ov.json"
resolve "$FILAMENT" "$WORK/filament.json"

stl() { # size part file
    local l=${1%x*} wd=${1#*x}
    "$OPENSCAD" --backend=manifold $STUDS -D studs_l=$l -D studs_w=$wd -D "part=\"$2\"" -o "$3" "$SCAD" 2>&1 | grep -E 'WARNING|ERROR' || true
}
project() { # 3mf stl...
    local out=$1; shift
    local stls=(); for s in "$@"; do stls+=("$(w "$s")"); done
    "$BAMBU" --arrange 1 --orient 0 --load-settings "$(w "$WORK/machine.json");$(w "$WORK/process.json")" \
        --load-filaments "$(w "$WORK/filament.json")" --export-3mf "$(w "$out")" "${stls[@]}"
    [ -s "$out" ] || { echo "failed: $out" >&2; exit 1; }
    echo "built $out"
}

for sz in "${SIZES[@]}"; do
    mode=$MODE
    [ "$mode" = auto ] && { [ "${sz#*x}" -le 5 ] && mode=pip || mode=two; }
    if [ "$mode" = pip ]; then
        stl "$sz" print_in_place "$WORK/brick box $sz print in place.stl"
        project "$OUT/brick_box_${sz}_print_in_place.3mf" "$WORK/brick box $sz print in place.stl"
    else
        stl "$sz" body "$WORK/brick box $sz body.stl"
        stl "$sz" lid "$WORK/brick box $sz lid.stl"
        project "$OUT/brick_box_${sz}.3mf" "$WORK/brick box $sz body.stl" "$WORK/brick box $sz lid.stl"
    fi
done
