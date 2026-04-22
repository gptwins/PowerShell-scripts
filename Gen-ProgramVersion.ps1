Param(
    [switch] $Version
)

$ProgramVersion = "1.1.26112"
$ProgramName = $MyInvocation.MyCommand.Name

if( $Version) { 
    Write-Host "$ProgramName`: $ProgramVersion"
    exit 0
}

$MajorVersion = Read-Host "Major Version Number"
$MinorVersion = Read-host "Minor Version Number"
$ShortYearBuilt = get-date -UFormat "%y"
$DayOfYear = (get-date).dayofyear

$DayOfYear = $DayOfYear.toString("0##")

Write-host ""
Write-host '$ProgramName = $MyInvocation.MyCommand.Name'
Write-Host "`$ProgramVersion = `"$majorversion.$minorversion.$shortyearbuilt$dayofyear`""
Write-Host "`nif( `$Version ) {`nWrite-host `"`$ProgramName``: `$ProgramVersion`"`nexit 0`n }"