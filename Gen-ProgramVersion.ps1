Param(
    [int32] $Version,
    [int32] $MinorVersion,
    [int32] $YearBuilt,
    [int32] $DayOfYear
)

if( $Version -eq "") { $Version = Read-Host "Major Version Number: " }
if( $MinorVersion -eq "") { $MinorVersion = Read-host "Minor Version Number: " }
if( $YearBuilt -eq "") { $YearBuilt = get-date -UFormat "%Y" }
if( $DayofYear -eq "") { $DayOfYear = (get-date).dayofyear }

Write-Host "`$Version = $version.$minorversion.$yearbuilt.$dayofyear"
Write-Host "`$Version = $version`n`$MinorVersion = $minorversion`n`$MajorBuild = $yearbuilt`n`$MinorBuild = $dayofyear"