# Marks process settings as changed from the system preset in a Bambu Studio project, so
# Studio keeps them when it opens the .3mf instead of reloading the system values (the CLI
# leaves different_settings_to_system empty). With a third argument, objects whose name
# contains it get tree supports from the bed of their own.
# Usage: mark_changed.ps1 <project.3mf> <overrides.json> [object name match]
param([string]$Project, [string]$Overrides, [string]$SupportObject = "")

Add-Type -AssemblyName System.IO.Compression, System.IO.Compression.FileSystem
$keys = (Get-Content -Raw -Encoding UTF8 $Overrides | ConvertFrom-Json).PSObject.Properties.Name |
    Where-Object { $_ -ne "curr_bed_type" } | Sort-Object

function Edit-Entry($zip, [string]$name, [scriptblock]$edit) {
    $entry = $zip.GetEntry($name)
    $r = New-Object IO.StreamReader($entry.Open()); $text = $r.ReadToEnd(); $r.Close()
    $new = & $edit $text
    $entry.Delete()
    $w = New-Object IO.StreamWriter(($zip.CreateEntry($name)).Open(), (New-Object Text.UTF8Encoding($false)))
    $w.Write($new); $w.Close()
}

$zip = [IO.Compression.ZipFile]::Open($Project, "Update")
try {
    Edit-Entry $zip "Metadata/project_settings.config" {
        param($text)
        # the list runs process, filaments..., printer: fill in the first (process) slot
        $new = [regex]::Replace($text, '("different_settings_to_system": \[\s*)"[^"]*"', ('$1"' + ($keys -join ";") + '"'), 1)
        if ($new -eq $text) { throw "different_settings_to_system not found in $Project" }
        $new
    }
    if ($SupportObject) {
        Edit-Entry $zip "Metadata/model_settings.config" {
            param($text)
            $sup = "`n    <metadata key=`"enable_support`" value=`"1`"/>" +
                   "`n    <metadata key=`"support_type`" value=`"tree(auto)`"/>" +
                   "`n    <metadata key=`"support_on_build_plate_only`" value=`"1`"/>"
            $pat = '(<object id="\d+">\s*<metadata key="name" value="[^"]*' + [regex]::Escape($SupportObject) + '[^"]*"/>)'
            $new = [regex]::Replace($text, $pat, ('$1' + $sup))
            if ($new -eq $text) { throw "no object named like '$SupportObject' in $Project" }
            $new
        }
    }
} finally { $zip.Dispose() }
"marked changed: {0}{1}" -f ($keys -join ", "), $(if ($SupportObject) { "; supports on *$SupportObject*" } else { "" })
