# Flattens a Bambu Studio system preset: merges its whole "inherits" chain into one JSON,
# then applies optional overrides. Usage: resolve.ps1 <dir> <preset name> <out file> [overrides.json]
param([string]$Dir, [string]$Name, [string]$Out, [string]$Overrides = "")

$index = @{}
Get-ChildItem -Path $Dir -Filter *.json -Recurse | ForEach-Object {
    try { $j = Get-Content -Raw -Encoding UTF8 $_.FullName | ConvertFrom-Json; if ($j.name) { $index[$j.name] = $_.FullName } } catch {}
}

function Resolve-Preset([string]$n) {
    if (-not $index.ContainsKey($n)) { throw "preset not found: $n" }
    $j = Get-Content -Raw -Encoding UTF8 $index[$n] | ConvertFrom-Json
    $merged = [ordered]@{}
    if ($j.inherits) { $parent = Resolve-Preset $j.inherits; foreach ($k in $parent.Keys) { $merged[$k] = $parent[$k] } }
    foreach ($p in $j.PSObject.Properties) { $merged[$p.Name] = $p.Value }
    return $merged
}

$r = Resolve-Preset $Name
if ($Overrides) { (Get-Content -Raw -Encoding UTF8 $Overrides | ConvertFrom-Json).PSObject.Properties | ForEach-Object { $r[$_.Name] = $_.Value } }
$r.Remove("inherits")
$r["name"] = $Name
$r["from"] = "system"
[IO.File]::WriteAllText($Out, ($r | ConvertTo-Json -Depth 20), (New-Object System.Text.UTF8Encoding($false)))
"{0}: {1} keys" -f $Name, $r.Count
