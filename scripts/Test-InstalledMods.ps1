param([string]$WorkshopRoot='C:\Program Files (x86)\Steam\steamapps\workshop\content\294100')
$ErrorActionPreference='Stop'
. "$PSScriptRoot/Test-Xml.ps1"
$ids=@('3219596926','2787850474','3444347874')
$evidence=@()
foreach($ideology in @($false,$true)) {
 [xml]$doc='<Defs />'; $names=@()
 foreach($i in 0..2) {
  $modPath=Join-Path $WorkshopRoot $ids[$i]
  [xml]$meta=Get-Content "$modPath/About/About.xml" -Raw
  Assert ($meta.ModMetaData.name -ceq $groups[$i].Name) 'Upstream guard name changed'
  Assert ($meta.ModMetaData.supportedVersions.li -contains '1.6') 'Upstream no longer declares 1.6'
  $names+=$meta.ModMetaData.name
  $folders=@('Defs','1.6/Defs')
  if($ideology){$folders+='1.6/Mods/Ideology/Defs'}
  foreach($folder in $folders) { if(Test-Path "$modPath/$folder") {
   foreach($file in Get-ChildItem "$modPath/$folder" -Filter *.xml -Recurse) {
    [xml]$defs=Get-Content $file.FullName -Raw
    foreach($def in $defs.SelectNodes('Defs/ThingDef')) {
     [void]$doc.DocumentElement.AppendChild($doc.ImportNode($def,$true))
    }
   }
  } }
  $evidence += "$($ids[$i]): $($meta.ModMetaData.name)"
 }
 $before=@{}
 foreach($group in $groups){ foreach($entry in $group.Defs.GetEnumerator()) {
  if($entry.Key -eq 'VFEM2_HearthDarklight' -and !$ideology){continue}
  $targetDefs=$doc.SelectNodes("Defs/ThingDef[defName='$($entry.Key)']")
  Assert ($targetDefs.Count -eq 1) "Missing or duplicate installed def $($entry.Key)"
  Assert ($null -ne $targetDefs[0].comps) "Target requires inheritance resolution: $($entry.Key)"
  Assert ($targetDefs[0].SelectNodes("comps/li[@Class='CompProperties_Flickable']").Count -eq 0) 'Switch already present upstream'
  $before[$entry.Key]=$targetDefs[0].comps.InnerXml
  if($entry.Value){Assert ($targetDefs[0].SelectNodes("comps/li[@Class='$($entry.Value)']").Count -eq 1) "Overlay changed: $($entry.Key)"}
 } }
 foreach($patch in $patches){foreach($op in $patch.Patch.Operation){Apply-Operation $op $doc $names $ideology}}
 foreach($group in $groups){foreach($entry in $group.Defs.GetEnumerator()){
  if(!$before.ContainsKey($entry.Key)){continue}
  $comps=$doc.SelectSingleNode("Defs/ThingDef[defName='$($entry.Key)']/comps")
  Assert ($comps.SelectNodes("li[@Class='CompProperties_Flickable']").Count -eq 1) 'Switch missing/duplicated'
  [void]$comps.RemoveChild($comps.SelectSingleNode("li[@Class='CompProperties_Flickable']"))
  if($entry.Value){
   $overlay=$comps.SelectSingleNode("li[@Class='$($replacements[$entry.Value])']")
   Assert ($null -ne $overlay) 'Replacement overlay missing'
   $overlay.SetAttribute('Class',$entry.Value)
  }
  Assert ($comps.InnerXml -ceq $before[$entry.Key]) 'Existing properties altered'
 }}
 Write-Host "PASS: installed 1.6 defs, Ideology=$ideology, $($before.Count) targets."
}
# Inspect PE metadata without loading or executing third-party game code.
function Get-Types($dll) {
 $stream=[IO.File]::OpenRead($dll)
 $pe=[System.Reflection.PortableExecutable.PEReader]::new($stream)
 try {
  $reader=[System.Reflection.Metadata.PEReaderExtensions]::GetMetadataReader($pe)
  foreach($handle in $reader.TypeDefinitions){$type=$reader.GetTypeDefinition($handle); $reader.GetString($type.Namespace)+'.'+$reader.GetString($type.Name)}
 } finally {$pe.Dispose();$stream.Dispose()}
}
$continued="$WorkshopRoot/3772905265/Assemblies/ExtinguishRefuelablesContinued.dll"
$types=@(Get-Types $continued)+@(Get-Types "$PSScriptRoot/../Mod/Assemblies/ExtinguishRefuelablesPatch.dll")
foreach($type in $replacements.Values){Assert ($type -cin $types) "Missing shipped type: $type"}
$basePatchText=(Get-ChildItem "$WorkshopRoot/3772905265/Patches" -Filter *.xml -Recurse | Get-Content -Raw) -join "`n"
foreach($group in $groups){foreach($defName in $group.Defs.Keys){Assert (!$basePatchText.Contains($defName)) "Continued now overlaps $defName"}}
Write-Host 'PASS: replacement types present in DLL metadata; no Continued patch target overlap.'
$evidence | Sort-Object -Unique
