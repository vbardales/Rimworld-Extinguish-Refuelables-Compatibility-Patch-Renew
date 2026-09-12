$ErrorActionPreference='Stop'
Add-Type -Path "$PSScriptRoot/BehaviourHarness.cs", "$PSScriptRoot/../Source/CompFireOverlaySouthExtinguishable.cs"
$count=[BehaviourHarness]::Run()
Write-Host "PASS: $count C# cases against test doubles; no game engine launched."
