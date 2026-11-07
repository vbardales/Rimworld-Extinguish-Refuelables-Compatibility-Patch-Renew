param([Parameter(Mandatory)][string]$ModRoot, [string]$SharedDir, [string]$WorkshopRoot = 'C:\Program Files (x86)\Steam\steamapps\workshop\content\294100')

# Needs PowerShell 7 (C# 6+ for Add-Type, System.Reflection.Metadata): the generated Test-Mod.ps1 starts rules with Windows PowerShell, so re-run in pwsh when it is there.
if ($PSVersionTable.PSEdition -eq 'Desktop') { $pw = Get-Command pwsh -ErrorAction SilentlyContinue; if ($pw) { $fwd = @('-ModRoot', $ModRoot); if ($SharedDir) { $fwd += '-SharedDir', $SharedDir }; if ($PSBoundParameters.ContainsKey('WorkshopRoot')) { $fwd += '-WorkshopRoot', $WorkshopRoot }; & $pw.Source -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath @fwd; exit $LASTEXITCODE } }

# Own values and facts of this patch: the 13 target buildings, the overlay class each one gets, the three mod-name guards,
# the Ideology guard of the darklight hearth, the About identity and dependencies, the single shipped DLL.
# One consumer, nothing shareable; Tests/Test-Mod.ps1 (generated) runs it after the shared checks. Prints findings, exit 1 on any.
# Generic checks live in the shared scripts: Check-ModBasics (XML, About shape, "(unofficial)", images), Check-PatchTargets
# (every patch xpath still matches the installed mod), the PatchEngine (applies the patch files to a fixture or to the real defs).
# The checks against the installed Steam mods are skipped, loudly, when the Workshop folder is absent (the GitHub runner).
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $ModRoot).Path
$mod = Join-Path $root 'Mod'
$script:findings = @()
function It([string]$name, [scriptblock]$body) {
    try { $problems = @(& $body | Where-Object { $_ }) } catch { $problems = @("threw: $($_.Exception.GetBaseException().Message)") }
    foreach ($p in $problems) { $script:findings += "[$name] $p" }
}

$engine = @((Join-Path $SharedDir 'lib/PatchEngine.ps1'), (Join-Path $root 'Tests/lib/PatchEngine.ps1')) | Where-Object { $_ -and (Test-Path -LiteralPath $_) } | Select-Object -First 1
if (-not $engine) { Write-Host 'FAIL PatchEngine.ps1 not found (shared lib, then Tests/lib): the patch contract did NOT run'; exit 1 }
. $engine

$ideologyId = 'Ludeon.RimWorld.Ideology'
# The 13 targets: def name -> the overlay class that must be there before the patch ('' = the def has no overlay, it only gets the switch).
$groups = @(
    @{ Name = 'Medieval Overhaul'; Id = '3219596926'; PackageId = 'DankPyon.Medieval.Overhaul'; File = 'MedievalOverhaul.xml'; Defs = [ordered]@{
        DankPyon_Brazier2x2c = 'CompProperties_FireOverlay'; DankPyon_Brazier1x1c = 'CompProperties_FireOverlay'
        DankPyon_Candles = ''; DankPyon_Candles_Beeswax = ''; DankPyon_CandleStand = ''
        DankPyon_WallLamp = ''; DankPyon_LampPost = ''; DankPyon_WallTorch = 'CompProperties_FireOverlay'
        DankPyon_WoodBurningStove = 'MedievalOverhaul.CompProperties_FireOverlaySouth'
        DankPyon_RusticHearth = 'MedievalOverhaul.CompProperties_FireOverlaySouth' } },
    @{ Name = 'Vanilla Factions Expanded - Classical'; Id = '2787850474'; PackageId = 'OskarPotocki.VFE.Classical'; File = 'VanillaFactionsExpandedClassical.xml'; Defs = [ordered]@{
        VFEC_HeatStones = '' } },
    @{ Name = 'Vanilla Factions Expanded - Medieval 2'; Id = '3444347874'; PackageId = 'OskarPotocki.VFE.Medieval2'; File = 'VanillaFactionsExpandedMedieval2.xml'; Defs = [ordered]@{
        VFEM2_Hearth = 'CompProperties_FireOverlay'; VFEM2_HearthDarklight = 'CompProperties_DarklightOverlay' } }
)
$replacements = @{
    'CompProperties_FireOverlay' = 'ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable'
    'MedievalOverhaul.CompProperties_FireOverlaySouth' = 'ExtinguishRefuelablesPatch.CompProperties_FireOverlaySouthExtinguishable'
    'CompProperties_DarklightOverlay' = 'ExtinguishRefuelables.CompProperties_DarklightOverlayExtinguishable'
}
$patchFiles = @($groups | ForEach-Object { Join-Path $mod "Patches/$($_.File)" })

It 'About: identity, one hard dependency, the three targets loaded after it, Keshash incompatible, 1.6 only' {
    [xml]$about = Get-Content -LiteralPath (Join-Path $mod 'About/About.xml') -Raw -Encoding UTF8
    $m = $about.ModMetaData
    if ($m.packageId -cne 'nelim.extinguishrefuelablescompatibilitypatch') { "Wrong packageId: $($m.packageId)" }
    if (@($m.modDependencies.li.packageId) -join ',' -cne 'blacktriple.extinguishrefuelablescontinued') { "modDependencies must be Extinguish Refuelables Continued only" }
    foreach ($id in @('blacktriple.extinguishrefuelablescontinued') + @($groups.PackageId)) { if ($id -notin @($m.loadAfter.li)) { "loadAfter lacks $id" } }
    if ('Keshash.ExtinguishRefuelablesPatch' -notin @($m.incompatibleWith.li)) { 'incompatibleWith lacks Keshash.ExtinguishRefuelablesPatch' }
    if (@($m.supportedVersions.li) -join ',' -ne '1.6') { "supportedVersions must be 1.6 only, got $(@($m.supportedVersions.li) -join ',')" }
    if (-not $m.description.Contains([string]$m.url)) { 'GitHub URL missing from the description' }
}
It 'Shipped files: three patch files, one DLL, no LoadFolders' {
    $found = @(Get-ChildItem -LiteralPath (Join-Path $mod 'Patches') -Filter *.xml | Select-Object -ExpandProperty Name | Sort-Object)
    $want = @($groups.File | Sort-Object)
    if (($found -join ',') -ne ($want -join ',')) { "Patch files differ: $($found -join ', ')" }
    $dlls = @(Get-ChildItem -LiteralPath (Join-Path $mod 'Assemblies') -Filter *.dll | Select-Object -ExpandProperty Name)
    if (($dlls -join ',') -cne 'ExtinguishRefuelablesPatch.dll') { "Assemblies must hold ExtinguishRefuelablesPatch.dll only, got $($dlls -join ', ')" }
    if (Test-Path -LiteralPath (Join-Path $mod 'LoadFolders.xml')) { 'LoadFolders.xml is not expected: every patch is guarded by FindMod' }
}
It 'Guards: every FindMod names exactly one of the three mods, each file its own mod; MayRequire only on the Ideology list items' {
    foreach ($group in $groups) {
        [xml]$doc = Get-Content -LiteralPath (Join-Path $mod "Patches/$($group.File)") -Raw -Encoding UTF8
        foreach ($op in $doc.SelectNodes('/Patch/Operation')) {
            if ($op.GetAttribute('Class') -ne 'PatchOperationFindMod') { "$($group.File): a top-level operation is not a FindMod" }
            elseif (@($op.mods.li).Count -ne 1 -or $op.mods.li -cne $group.Name) { "$($group.File): FindMod must name only '$($group.Name)'" }
            if ($op.HasAttribute('MayRequire')) { "$($group.File): MayRequire on a top-level operation is never read by the game" }
        }
        foreach ($node in $doc.SelectNodes('//*[@MayRequire]')) {
            if ($node.GetAttribute('MayRequire') -cne $ideologyId) { "$($group.File): MayRequire is not $ideologyId" }
            if ($node.Name -ne 'li') { "$($group.File): MayRequire on <$($node.Name)>, honoured on list items only" }
            if ($group.Name -ne 'Vanilla Factions Expanded - Medieval 2') { "$($group.File): only the darklight hearth is behind Ideology" }
        }
    }
    [xml]$m2 = Get-Content -LiteralPath (Join-Path $mod 'Patches/VanillaFactionsExpandedMedieval2.xml') -Raw -Encoding UTF8
    if (@($m2.SelectNodes('//li[@MayRequire]')).Count -ne 2) { 'The two darklight operations must both carry MayRequire' }
}
It 'Contract on fixtures: 8 mod combinations x with/without Ideology, 13 targets get one switch first, the overlay swapped, nothing else touched' {
    foreach ($mask in 0..7) { foreach ($ideology in @($false, $true)) {
        $active = @(); $expected = [ordered]@{}
        [xml]$doc = '<Defs><ThingDef><defName>Unrelated</defName><comps><li Class="Sentinel" /></comps></ThingDef></Defs>'
        foreach ($i in 0..2) { if ($mask -band (1 -shl $i)) {
            $active += $groups[$i].Name
            foreach ($entry in $groups[$i].Defs.GetEnumerator()) {
                if ($entry.Key -eq 'VFEM2_HearthDarklight' -and -not $ideology) { continue }
                $expected[$entry.Key] = $entry.Value
                $def = $doc.CreateElement('ThingDef'); $def.InnerXml = "<defName>$($entry.Key)</defName><comps><li Class='Sentinel' /></comps>"
                if ($entry.Value) {
                    $overlay = $doc.CreateElement('li'); $overlay.SetAttribute('Class', $entry.Value)
                    $overlay.InnerXml = '<fireSize>1.7</fireSize><offset>(0,0,0.2)</offset>'
                    [void]$def.SelectSingleNode('comps').AppendChild($overlay)
                }
                [void]$doc.DocumentElement.AppendChild($def)
            }
        } }
        $label = "mods=[$($active -join ' + ')] ideology=$ideology"
        # The engine does not read MayRequire: without Ideology the darklight def is not in the fixture, so its two operations match nothing, as in the game.
        foreach ($file in $patchFiles) { Invoke-PatchFile -Path $file -Doc $doc -ActiveMods $active -RequireMatch:$ideology }
        foreach ($entry in $expected.GetEnumerator()) {
            $comps = $doc.SelectSingleNode("Defs/ThingDef[defName='$($entry.Key)']/comps")
            if ($comps.SelectNodes("li[@Class='CompProperties_Flickable']").Count -ne 1) { "$label : $($entry.Key) has no single switch" }
            if ($comps.FirstChild.GetAttribute('Class') -ne 'CompProperties_Flickable') { "$label : $($entry.Key) switch is not first" }
            if ($comps.SelectNodes("li[@Class='Sentinel']").Count -ne 1) { "$label : $($entry.Key) lost an existing comp" }
            if ($entry.Value) {
                $overlay = $comps.SelectSingleNode("li[@Class='$($replacements[$entry.Value])']")
                if (-not $overlay) { "$label : $($entry.Key) overlay not swapped to $($replacements[$entry.Value])" }
                elseif ($overlay.fireSize -ne '1.7' -or $overlay.offset -ne '(0,0,0.2)') { "$label : $($entry.Key) overlay properties changed" }
            } elseif ($comps.ChildNodes.Count -ne 2) { "$label : $($entry.Key) got an overlay it must not have" }
        }
        if ($doc.SelectSingleNode("Defs/ThingDef[defName='Unrelated']/comps").InnerXml -ne '<li Class="Sentinel" />') { "$label : an unrelated def changed" }
    } }
}

$installed = Test-Path -LiteralPath (Join-Path $WorkshopRoot $groups[0].Id)
if (-not $installed) { Write-Host "WARNING installed-mod checks SKIPPED, not passed: no Workshop folder at $WorkshopRoot" }
else {
    It 'Installed 1.6 mods: the guard names are the real names, the 13 targets exist once with no switch, the patch applies and leaves the rest as it was' {
        foreach ($ideology in @($false, $true)) {
            [xml]$doc = '<Defs />'; $names = @()
            foreach ($group in $groups) {
                $path = Join-Path $WorkshopRoot $group.Id
                [xml]$meta = Get-Content -LiteralPath (Join-Path $path 'About/About.xml') -Raw -Encoding UTF8
                if ($meta.ModMetaData.name -cne $group.Name) { "Upstream name changed: $($meta.ModMetaData.name) (guard says $($group.Name))" }
                if ('1.6' -notin @($meta.ModMetaData.supportedVersions.li)) { "$($group.Name) no longer declares 1.6" }
                $names += $meta.ModMetaData.name
                $folders = @('Defs', '1.6/Defs'); if ($ideology) { $folders += '1.6/Mods/Ideology/Defs' }
                foreach ($folder in $folders) { if (Test-Path -LiteralPath (Join-Path $path $folder)) {
                    foreach ($file in Get-ChildItem -LiteralPath (Join-Path $path $folder) -Filter *.xml -Recurse) {
                        [xml]$defs = Get-Content -LiteralPath $file.FullName -Raw -Encoding UTF8
                        foreach ($def in $defs.SelectNodes('Defs/ThingDef')) { [void]$doc.DocumentElement.AppendChild($doc.ImportNode($def, $true)) }
                    }
                } }
            }
            $before = @{}
            foreach ($group in $groups) { foreach ($entry in $group.Defs.GetEnumerator()) {
                if ($entry.Key -eq 'VFEM2_HearthDarklight' -and -not $ideology) { continue }
                $hits = @($doc.SelectNodes("Defs/ThingDef[defName='$($entry.Key)']"))
                if ($hits.Count -ne 1) { "Ideology=${ideology}: $($entry.Key) found $($hits.Count) times upstream"; continue }
                if ($null -eq $hits[0].comps) { "Ideology=${ideology}: $($entry.Key) has no comps of its own (inheritance, not handled)"; continue }
                if ($hits[0].SelectNodes("comps/li[@Class='CompProperties_Flickable']").Count) { "Ideology=${ideology}: $($entry.Key) already has a switch upstream" }
                if ($entry.Value -and $hits[0].SelectNodes("comps/li[@Class='$($entry.Value)']").Count -ne 1) { "Ideology=${ideology}: $($entry.Key) overlay is no longer $($entry.Value)" }
                $before[$entry.Key] = $hits[0].comps.InnerXml
            } }
            foreach ($file in $patchFiles) { Invoke-PatchFile -Path $file -Doc $doc -ActiveMods $names -RequireMatch:$ideology }
            foreach ($group in $groups) { foreach ($entry in $group.Defs.GetEnumerator()) {
                if (-not $before.ContainsKey($entry.Key)) { continue }
                $comps = $doc.SelectSingleNode("Defs/ThingDef[defName='$($entry.Key)']/comps")
                $switch = $comps.SelectSingleNode("li[@Class='CompProperties_Flickable']")
                if (-not $switch) { "Ideology=${ideology}: $($entry.Key) has no switch after the patch"; continue }
                [void]$comps.RemoveChild($switch)
                if ($entry.Value) {
                    $overlay = $comps.SelectSingleNode("li[@Class='$($replacements[$entry.Value])']")
                    if (-not $overlay) { "Ideology=${ideology}: $($entry.Key) overlay not swapped"; continue }
                    $overlay.SetAttribute('Class', $entry.Value)
                }
                if ($comps.InnerXml -cne $before[$entry.Key]) { "Ideology=${ideology}: $($entry.Key) existing properties altered" }
            } }
        }
    }
    It 'Replacement types exist in the two DLLs; Extinguish Refuelables Continued patches none of the 13 targets' {
        $continued = Join-Path $WorkshopRoot '3772905265'
        $types = @()
        foreach ($dll in @((Join-Path $continued 'Assemblies/ExtinguishRefuelablesContinued.dll'), (Join-Path $mod 'Assemblies/ExtinguishRefuelablesPatch.dll'))) {
            $stream = [IO.File]::OpenRead($dll); $pe = [System.Reflection.PortableExecutable.PEReader]::new($stream)
            try {
                $reader = [System.Reflection.Metadata.PEReaderExtensions]::GetMetadataReader($pe)
                foreach ($h in $reader.TypeDefinitions) { $t = $reader.GetTypeDefinition($h); $types += $reader.GetString($t.Namespace) + '.' + $reader.GetString($t.Name) }
            } finally { $pe.Dispose(); $stream.Dispose() }
        }
        foreach ($type in $replacements.Values) { if ($type -cnotin $types) { "Missing shipped type: $type" } }
        $text = (Get-ChildItem -LiteralPath (Join-Path $continued 'Patches') -Filter *.xml -Recurse | ForEach-Object { Get-Content -LiteralPath $_.FullName -Raw }) -join "`n"
        foreach ($group in $groups) { foreach ($name in $group.Defs.Keys) { if ($text.Contains($name)) { "Continued now patches $name too" } } }
    }
}

if ($script:findings.Count) { $script:findings | ForEach-Object { Write-Host $_ }; exit 1 }
Write-Host 'PASS: own values of Extinguish Refuelables Compatibility Patch (About, files, guards, 16 fixture combinations, installed 1.6 defs).'
