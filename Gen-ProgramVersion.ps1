Param(
    [string] $MajorVersion,
    [string] $MinorVersion,
    [string] $YearBuilt,
    [string] $ShortYearBuilt,
    [string] $DayOfYear,
    [switch] $ShortBuild,
    [switch] $Version
)

$ProgramVersion = "1.1.25231"
$ProgramName = $MyInvocation.MyCommand.Name

if( $Version) { 
    Write-Host "$ProgramName`: $ProgramVersion"
    exit 0
}

if( $MajorVersion -eq "") { $MajorVersion = Read-Host "Major Version Number" }
if( $MinorVersion -eq "") { $MinorVersion = Read-host "Minor Version Number" }
if( $YearBuilt -eq "") { $YearBuilt = get-date -UFormat "%Y" }
if( $ShortYearBuilt -eq "") { $ShortYearBuilt = get-date -UFormat "%y" }
if( $DayofYear -eq "") { $DayOfYear = (get-date).dayofyear }

Write-host '$ProgramName = $MyInvocation.MyCommand.Name'
if ( $ShortBuild ) { Write-Host "`$ProgramVersion = `"$majorversion.$minorversion.$shortyearbuilt$dayofyear`"" }
else { Write-Host "`$ProgramVersion = `"$majorversion.$minorversion.$yearbuilt.$dayofyear`"" }
