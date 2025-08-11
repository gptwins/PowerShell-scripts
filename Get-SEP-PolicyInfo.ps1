<#
    .SYNOPSIS
    A quick PowerShell script to return the Trend Vision One Standard Endpoint Protection/Apex One agent install directory, server name/address, installed program version and build number, policy name applied, and the last time the policy was applied.

    .DESCRIPTION
    The script reads the Windows registry to determine of the Vision One Standard Endpoint Protection/Apex One agent is installed.  It returns the installation directory, the fully qualified server name or IP address of the server, the installed SEP/Apex One version and build number, the SEP/Apex One agent policy that is currently applied, and the last date/time the policy was applied to the agent.

    .PARAMETER Version
    There is only one available switch, that is to show the current version number of the script.

    .EXAMPLE
    PS > .\Get-SEP-PolicyInfo.ps1
    Agent Installation Directory: C:\Program Files (x86)\Trend Micro\Security Agent\
    Server Address: xxxxx.manage.trendmicro.com
    Program Version: 14.0
    Program Build Number: 20114
    Policy Name: GlenGeen-Lab
    Last Update Time: 2025-07-31 15:29:59

    .EXAMPLE
    PS C:\Users\gdgee\src\ps1> .\Get-SEP-PolicyInfo.ps1 -Version
    Get-SEP-PolicyInfo.ps1
    Version: 1.0.2025.213

.NOTES
    Author: G D Geen
    Date-written: 1 Aug 2025
#>

Param (
    [switch] $Version
)
########################################################################
# Configure script operation
########################################################################
$ErrorActionPreference = 'SilentlyContinue'

########################################################################
# Set variables
########################################################################
$ProgramName = $MyInvocation.MyCommand.Name
$ProgramVersion = "1.0.2025.223"
$AgentPath = ""
$ServerAddr = ""

if( $Version ) { 
    Write-Host "$ProgramName`nVersion`: $ProgramVersion"
    exit 0
}

$AgentPath =  (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion -Name "Application Path")."Application Path"
$ServerAddr = (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion -Name "Server")."Server"
$ProgramVer = (get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion\Misc. -Name "ProgramVer")."ProgramVer"
$BuildNum = (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion\Misc. -Name "BuildNum")."BuildNum"

if( $AgentPath -ne "") {
"Agent Installation Directory: $AgentPath"
"Server Address: $ServerAddr"
"Program Version: $ProgramVer"
"Program Build Number: $BuildNum"
"Policy Name: "+(Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion\Misc.\ -name "CMAPolicy0_Name" |select-object CMAPolicy0_Name).CMAPolicy0_Name
"Last Update Time: "+(Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion\Misc.\ -name "CMAPolicy0_LastUpdateTime" |select-object CMAPolicy0_LastUpdateTime).CMAPolicy0_LastUpdateTime
}
esle { "Agent does not appear to be installed." }