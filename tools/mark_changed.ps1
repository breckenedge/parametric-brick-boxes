# Marks process settings as changed from the system preset in a Bambu Studio project, so
# Studio keeps them when it opens the .3mf instead of reloading the system values (the CLI
# leaves different_settings_to_system empty). Usage: mark_changed.ps1 <project.3mf> <overrides.json>
param([string]$Project, [string]$Overrides)

Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$keys = (Get-Content -Raw -Encoding UTF8 $Overrides | ConvertFrom-Json).PSObject.Properties.Name |
    Where-Object { $_ -ne "curr_bed_type" } | Sort-Object
$zip = [IO.Compression.ZipFile]::Open($Project, "Update")
try {
    $entry = $zip.GetEntry("Metadata/project_settings.config")
    $r = New-Object IO.StreamReader($entry.Open()); $text = $r.ReadToEnd(); $r.Close()
    # the list runs process, filaments..., printer: fill in the first (process) slot
    $new = [regex]::Replace($text, '("different_settings_to_system": \[\s*)"[^"]*"', ('$1"' + ($keys -join ";") + '"'), 1)
    if ($new -eq $text -and $text -notmatch [regex]::Escape($keys -join ";")) { throw "different_settings_to_system not found in $Project" }
    $entry.Delete()
    $w = New-Object IO.StreamWriter(($zip.CreateEntry("Metadata/project_settings.config")).Open(), (New-Object Text.UTF8Encoding($false)))
    $w.Write($new); $w.Close()
} finally { $zip.Dispose() }
"marked changed: {0}" -f ($keys -join ", ")
