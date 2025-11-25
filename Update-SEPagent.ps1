<#
    .SYNOPSIS
    A quick PowerShell script to manually initiate an agent update from the endpoint.

    .DESCRIPTION
    The script reads the Windows registry to determine the installation directory of the Vision One Standard Endpoint Protection/Apex One agent.  It builds the command line string to initiate a manual, silient update of the agent.

    .PARAMETER Version
    Show the current version number of the script.

    .EXAMPLE
    PS > .\Update-SEPagent.ps1

    .EXAMPLE
    PS > .\Update-SEPagent.ps1 -Version
    Get-SEP-PolicyInfo.ps1
    Version: 1.0.25329

.NOTES
    Author: G D Geen
    Date-written: 25 Nov 2025
#>

Param (
    [switch] $Version
)

$ProgramName = $MyInvocation.MyCommand.Name
$ProgramVersion = "1.0.25329"

if( $Version ) { 
    Write-Host "$ProgramName`nVersion`: $ProgramVersion"
    exit 0
}


$AgentPath =  (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion -Name "Application Path")."Application Path"
$UpdateCommand = $AgentPath+"PccNTMon.exe"
& $UpdateCommand -us
