Param(
    [int32] $Version,
    [int32] $MinorVersion,
    [int32] $YearBuilt,
    [int32] $DayOfYear,
    [switch] $ShowVersion
)

$myVersion = "1.0.2025.204"
$ProgramName = $MyInvocation.MyCommand.Name

if( $ShowVersion) { 
    Write-Host "$ProgramName`: $myVersion"
    exit 0
}

if( $Version -eq "") { $Version = Read-Host "Major Version Number: " }
if( $MinorVersion -eq "") { $MinorVersion = Read-host "Minor Version Number: " }
if( $YearBuilt -eq "") { $YearBuilt = get-date -UFormat "%Y" }
if( $DayofYear -eq "") { $DayOfYear = (get-date).dayofyear }

Write-Host "`"`$Version = $version.$minorversion.$yearbuilt.$dayofyear`'"
Write-Host "`$Version = $version`n`$MinorVersion = $minorversion`n`$MajorBuild = $yearbuilt`n`$MinorBuild = $dayofyear"