<#
    .SYNOPSIS
    A quick powershell script to test for the existance of the OUS.ini file and to display the first 20 lines of the file.

    .DESCRIPTION
    This is a quick PowerShell script to test for the existance of the Vision One - Standard Endpoint Protection (V1-SEP) Other Update Source configuration file (OUS.ini).  We first get the agent installation directory from the system registry.  Using the installation directory we test for the existance of the ous.ini file and if it exists, we display the first 20 lines of its content.

    If the key value pair "AllowUpdateFromOtherAU" is set to "1" then the agent is going to look elsewhere for its agent and component updates.  Where those agents look is defined in the key value pairs OUS1..OUS64.

    .EXAMPLE
    PS > .\get-OUSini.ps1


    Directory: C:\Program Files (x86)\Trend Micro\Security Agent


Mode                 LastWriteTime         Length Name
----                 -------------         ------ ----
-a----         3/27/2026  11:58 AM            772 ous.ini
[Other Update Source]
AllowUpdateFromOtherAU=0
UpdateOUSSettingChangeFlag=0
AllowUncPath=0
UpdateFromServerIfOUSFailed=1
UpdateComponentFromServerIfOUSFailed=1
UpdateSettingFromServerIfOUSFailed=1
UpdateProgramFromServerIfOUSFailed=1
OUS1=
OUS2=
OUS3=
OUS4=
OUS5=
OUS6=
OUS7=
OUS8=
OUS9=
OUS10=
OUS11=
OUS12=

    .NOTES
    Author: G D Geen
#>

param ( [switch] $Version)
#Set program version
$ProgramName = $MyInvocation.MyCommand.Name
$ProgramVersion = "1.0.2686"

if( $Version ) {
Write-host "$ProgramName`: $ProgramVersion"
exit 0
 }


$AgentPath =  (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion -Name "Application Path")."Application Path"

if ($AgentPath -eq $null ) {
    Write-host "Agent installation directory not found in registry.  Likely cause is Standard Endpoint Protection is not installed on this endpoint."
    exit(1)
}

$UpdateSourceFile = "$AgentPath\ous.ini"

if ( test-path -path $UpdateSourceFile ) {
    get-childitem $UpdateSourceFile
    get-content $UpdateSourceFile -TotalCount 20
}
else {
    write-host "Could not find $UpdateSourceFile"
}
exit(0)