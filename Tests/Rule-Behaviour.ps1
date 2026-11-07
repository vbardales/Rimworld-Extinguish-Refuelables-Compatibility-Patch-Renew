param([Parameter(Mandatory)][string]$ModRoot, [string]$SharedDir)

# Needs PowerShell 7 (C# 6+ for Add-Type, System.Reflection.Metadata): the generated Test-Mod.ps1 starts rules with Windows PowerShell, so re-run in pwsh when it is there.
if ($PSVersionTable.PSEdition -eq 'Desktop') { $pw = Get-Command pwsh -ErrorAction SilentlyContinue; if ($pw) { $fwd = @('-ModRoot', $ModRoot); if ($SharedDir) { $fwd += '-SharedDir', $SharedDir }; & $pw.Source -NoProfile -ExecutionPolicy Bypass -File $PSCommandPath @fwd; exit $LASTEXITCODE } }

# The 72 fuel, switch, rotation and spawn cases of this mod's production C# (Source/CompFireOverlaySouthExtinguishable.cs), run against
# test doubles of the RimWorld, Verse and Unity names (Tests/BehaviourHarness.cs). Its own subject, apart from Rule-OwnValues: it
# compiles C# (Add-Type) and shares nothing with the XML rules. Tests/Test-Mod.ps1 (generated) runs it in a fresh process.
# Prints findings, exit 1 on any.
$ErrorActionPreference = 'Stop'
$root = (Resolve-Path -LiteralPath $ModRoot).Path
try {
    Add-Type -Path (Join-Path $root 'Tests/BehaviourHarness.cs'), (Join-Path $root 'Source/CompFireOverlaySouthExtinguishable.cs')
    $count = [BehaviourHarness]::Run()
} catch {
    Write-Host "[Behaviour] threw: $($_.Exception.GetBaseException().Message)"
    exit 1
}
if ($count -ne 72) { Write-Host "[Behaviour] expected 72 cases, ran $count"; exit 1 }
Write-Host "PASS: $count C# cases against test doubles; no game engine launched."
