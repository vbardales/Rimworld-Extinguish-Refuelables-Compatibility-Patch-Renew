$ErrorActionPreference = 'Stop'
$root = Split-Path $PSScriptRoot -Parent
function Assert($condition, $message) { if (!$condition) { throw $message } }
# Independent contract fixtures; these are NOT current upstream mod definitions.
$groups = @(
    @{ Name='Medieval Overhaul'; Defs=@{
        DankPyon_Brazier2x2c='CompProperties_FireOverlay'; DankPyon_Brazier1x1c='CompProperties_FireOverlay'
        DankPyon_Candles=''; DankPyon_Candles_Beeswax=''; DankPyon_CandleStand=''
        DankPyon_WallLamp=''; DankPyon_LampPost=''; DankPyon_WallTorch='CompProperties_FireOverlay'
        DankPyon_WoodBurningStove='MedievalOverhaul.CompProperties_FireOverlaySouth'
        DankPyon_RusticHearth='MedievalOverhaul.CompProperties_FireOverlaySouth'
    } },
    @{ Name='Vanilla Factions Expanded - Classical'; Defs=@{VFEC_HeatStones=''} },
    @{ Name='Vanilla Factions Expanded - Medieval 2'; Defs=@{
        VFEM2_Hearth='CompProperties_FireOverlay'; VFEM2_HearthDarklight='CompProperties_DarklightOverlay'
    } }
)
$replacements = @{
    CompProperties_FireOverlay='ExtinguishRefuelables.CompProperties_FireOverlayExtinguishable'
    'MedievalOverhaul.CompProperties_FireOverlaySouth'='ExtinguishRefuelablesPatch.CompProperties_FireOverlaySouthExtinguishable'
    CompProperties_DarklightOverlay='ExtinguishRefuelables.CompProperties_DarklightOverlayExtinguishable'
}
$patches = @(Get-ChildItem "$root/Mod/Patches/*.xml" | ForEach-Object { [xml](Get-Content $_ -Raw) })
function Apply-Operation($op, $doc, $active, $ideology) {
    if ($op.HasAttribute('MayRequire')) {
        Assert ($op.Name -eq 'li') 'MayRequire must be on a list element'
        Assert ($op.GetAttribute('MayRequire') -eq 'Ludeon.RimWorld.Ideology') 'Unexpected DLC guard'
        if (!$ideology) { return }
    }
    switch ($op.GetAttribute('Class')) {
        'PatchOperationFindMod' {
            Assert (@($op.mods.li).Count -eq 1) 'Expected one mod guard'
            Assert ($op.mods.li -in $groups.Name) 'Unknown mod name guard'
            if ($op.mods.li -in $active) { Apply-Operation $op.match $doc $active $ideology }
        }
        'PatchOperationSequence' { foreach ($child in $op.operations.li) { Apply-Operation $child $doc $active $ideology } }
        'PatchOperationAdd' {
            $nodes = @($doc.SelectNodes($op.xpath))
            Assert ($nodes.Count -gt 0) "Unmatched XPath: $($op.xpath)"
            Assert ($op.order -eq 'Prepend') 'Flickable must precede the overlay'
            foreach ($node in $nodes) { foreach ($child in $op.value.ChildNodes) {
                [void]$node.PrependChild($doc.ImportNode($child, $true))
            } }
        }
        'PatchOperationAttributeSet' {
            $nodes = @($doc.SelectNodes($op.xpath))
            Assert ($nodes.Count -gt 0) "Unmatched XPath: $($op.xpath)"
            foreach ($node in $nodes) { $node.SetAttribute([string]$op.attribute, [string]$op.value) }
        }
        default { throw "Unsupported operation: $($op.GetAttribute('Class'))" }
    }
}
Assert ($patches.Count -eq 3) 'Expected three patch files'
[xml]$about = Get-Content "$root/Mod/About/About.xml" -Raw
Assert ($about.ModMetaData.packageId -eq 'nelim.extinguishrefuelablescompatibilitypatchrenew') 'Wrong packageId'
Assert ($about.ModMetaData.name.EndsWith('(unofficial)')) 'Missing unofficial suffix'
Assert ($about.ModMetaData.description.Contains([string]$about.ModMetaData.url)) 'GitHub URL missing from description'
Assert ($about.ModMetaData.modDependencies.li.packageId -contains 'blacktriple.extinguishrefuelablescontinued') 'Missing dependency'
# All 8 combinations of target mods, with and without Ideology.
foreach ($mask in 0..7) { foreach ($ideology in @($false, $true)) {
    $active = @(); [xml]$doc = '<Defs><ThingDef><defName>Unrelated</defName><comps><li Class="Sentinel" /></comps></ThingDef></Defs>'
    $expected = @{}
    foreach ($i in 0..2) { if ($mask -band (1 -shl $i)) {
        $active += $groups[$i].Name
        foreach ($entry in $groups[$i].Defs.GetEnumerator()) {
            if ($entry.Key -eq 'VFEM2_HearthDarklight' -and !$ideology) { continue }
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
    foreach ($patch in $patches) { foreach ($op in $patch.Patch.Operation) { Apply-Operation $op $doc $active $ideology } }
    foreach ($entry in $expected.GetEnumerator()) {
        $comps = $doc.SelectSingleNode("Defs/ThingDef[defName='$($entry.Key)']/comps")
        Assert ($comps.SelectNodes("li[@Class='CompProperties_Flickable']").Count -eq 1) "Missing/duplicate switch: $($entry.Key)"
        Assert ($comps.FirstChild.GetAttribute('Class') -eq 'CompProperties_Flickable') 'Wrong comp order'
        Assert ($comps.SelectNodes("li[@Class='Sentinel']").Count -eq 1) 'Existing comp removed'
        if ($entry.Value) {
            $overlay = $comps.SelectSingleNode("li[@Class='$($replacements[$entry.Value])']")
            Assert ($null -ne $overlay) "Wrong overlay: $($entry.Key)"
            Assert ($overlay.fireSize -eq '1.7' -and $overlay.offset -eq '(0,0,0.2)') 'Overlay properties changed'
        } else { Assert ($comps.ChildNodes.Count -eq 2) 'Unexpected overlay added' }
    }
    Assert ($doc.SelectSingleNode("Defs/ThingDef[defName='Unrelated']/comps").InnerXml -eq '<li Class="Sentinel" />') 'Unrelated def changed'
} }
Write-Host 'PASS: metadata and XML patch contracts, 16 mod/DLC combinations.'
