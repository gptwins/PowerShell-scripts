param (
    [string] $Path,
    [int] $FileAge=30,
    [switch] $WhatIf
)

$AnchorDate=(get-date).AddDays(-$FileAge)
Write-output "Removing files older than $FileAge days in: $Path"
if ($WhatIf)
    { get-ChildItem -Path $Path -Recurse -Force |where-object {$_.CreationTime -lt $AnchorDate} |remove-item -Recurse -whatif }
else { get-ChildItem -Path  $Path -Recurse -Force |where-object {$_.CreationTime -lt $AnchorDate} |remove-item -Recurse }
