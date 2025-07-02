
########################################################################
# Create output directory structure
########################################################################
function fnCreateOutputDirectory {
    param( [string]$MyOutputDir )
    New-Item -ItemType Directory -Path $MyOutputDir
    New-Item -ItemType Directory -Path $MyOutputDir\server
    New-Item -ItemType Directory -Path $MyOutputDir\Edgesvr
    New-Item -ItemType Directory -Path $MyOutputDir\server\IISLogs
    New-Item -ItemType Directory -Path $MyOutputDir\server\TMSM
    New-Item -ItemType Directory -Path $MyOutputDir\client
    New-Item -ItemType Directory -Path $MyOutputDir\client\iES
    New-Item -ItemType Directory -Path $MyOutputDir\client\iAC
    New-Item -ItemType Directory -Path $MyOutputDir\client\iVP
    New-Item -ItemType Directory -Path $MyOutputDir\client\BM
    New-Item -ItemType Directory -Path $MyOutputDir\client\EndpointBasecamp
    New-Item -ItemType Directory -Path $MyOutputDir\client\AOT
    New-Item -ItemType Directory -Path $MyOutputDir\client\CloudEndpoint
    New-Item -ItemType Directory -Path $MyOutputDir\server\iES
    New-Item -ItemType Directory -Path $MyOutputDir\server\iAC
    New-Item -ItemType Directory -Path $MyOutputDir\server\iVP
    New-Item -ItemType Directory -Path $MyOutputDir\server\BM
    New-Item -ItemType Directory -Path $MyOutputDir\server\iATAS


}

########################################################################
# Get basic system information
########################################################################
function fnGetBasicSystemInfo
    {
    param( [string]$LocalWinDir )
    write-host "Retrieving system information..."
    & $LocalWinDir\System32\msinfo32.exe /nfo system.nfo
    Wait-Process -Name "msinfo32"
    write-host "Retrieving running processes..."
    Get-Process | Out-File tasklist.txt
    write-host "Retrieving running services..."
    Get-Service | Where-Object {$_.Status -eq "Running"} | Out-File services.txt
    Write-Host "Retrieving list of registered programs..."
    Get-WmiObject -Class win32_Product | Select-Object Name,Version | Out-File ProgramList.txt
    Write-Host "Retrieving network configurtion information..."
    Get-NetIPAddress | Format-List | Out-File -FilePath ip_config.txt
    Get-NetTCPConnection -Verbose | Out-File -FilePath "Get-NetTCPConnection.txt"
    Get-NetUDPEndpoint -Verbose | Out-File -FilePath "Get-NetUDPEndpoint.txt"
    }

########################################################################
# Get workstation registry information
########################################################################
function fnGetRegistries
    {
    Write-Host "Retrieving Trend Micro Registry information..."
    Get-ChildItem -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro -Recurse | Out-File TrendMicroWoW6432-reg.txt
    Get-ChildItem -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\TrendMicro -Recurse | Out-File TrendMicro-reg.txt
    Get-ChildItem -Path Registry::\HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services -Recurse | Out-File CuurentControlSetServices-reg.txt
    }

########################################################################
# Get Windows event logs (100 newest logs / error only)
########################################################################
function fnGetWindowsEventLogs
    {
    Write-Host "Retreiving the last 100 Application and System log entries..."
    Get-EventLog Application -newest 100 |where-object {$_.EntryType -eq "Error"} |Format-List |Out-File ApplicationEvtx-Error.txt
    Get-EventLog System -newest 100 |where-object {$_.EntryType -eq "Error"}|Format-List|Out-File SystemEvtx-Error.txt
    Get-EventLog Application -newest 100 |Format-List |Out-File ApplicationEvtx.txt
    Get-EventLog System -newest 100 |Format-List|Out-File SystemEvtx.txt
    
    }

########################################################################
# Get Trend Micro client log information
########################################################################
function fnGetClientInfo
    {
    param ( [string]$localAgentPath, [string]$localWinDir, [string]$localTempDir, [string]$localOutputDir)

    Write-Host "Retrieving client information..."    
    if (Test-Path $localAgentPath) 
        { 
        #get directory listing
        Get-ChildItem $localAgentPath -Recurse | Out-File client\dirlist.txt
        #get configuration files
        Copy-Item $localAgentPath\ofcscan.ini -Destination client\ofscan.ini
        Copy-Item $localAgentPath\ous.ini -Destination client\ous.ini
        Copy-Item $localAgentPath\hotfix_history.ini -Destination client\hotfix_history.ini
        Copy-Item $localAgentPath\ssnotify.ini -Destination client\ssnotify.ini
        #get log files
        Copy-Item $localWinDir\OFCNT.log -Destination client\
        Copy-Item $localTempDir\OFCNTINST.log -Destination client\
        Copy-Item $Env:SystemDrive\TmPatch.log -Destination client\
        Copy-Item $localWinDir\setupapi.log -Destination client\
        Copy-Item $localWinDir\inf\setupapi.app.log -Destination client\
        Copy-Item $localWinDir\inf\setupapi.dev.log -Destination client\
        Copy-Item $localAgentPath\Temp\upgrade_*.log -Destination client\
        Copy-Item $localAgentPath\ConnLog\Conn_*.log -Destination client\
        Copy-Item $localAgentPath\Misc\*.log -Destination client\
        Copy-Item $localAgentPath\Misc\*.db -Destination client\
        Copy-Item $localAgentPath\Misc\*.csv -Destination client\
        Copy-Item $localAgentPath\report\*.log -Destination client\
        Copy-Item $localAgentPath\Whitelist\*.db -Destination client\
        Copy-Item $localAgentPath\*.db -Destination client\
        Copy-Item $localAgentPath\AU_Data\AU_Log\TmuDump.txt -Destination client\
        #get Applications Control logs
        Copy-Item $localAgentPath\..\iService\iAC\messages.log -Destination client\iAC
        Copy-Item $localAgentPath\..\iService\iAC\ac_logs\JsonDownload_Dump.txt client\iAC
        Copy-Item $localAgentPath\..\iService\iAC\AcAgentMain.* client\iAC
        Copy-Item $localAgentPath\..\iService\iAC\AcAgentMonitor.* client\iAC
        #get Vulnerability Protection logs
        Copy-Item $localAgentPath\..\iService\iVP\vp_agent.log client\iVP
        Copy-Item $localAgentPath\..\iService\iVP\vp_install.log client\iVP
        Copy-Item $localAgentPath\..\iService\iVP\config\vp_agent.ini client\iVP
        #get Endpoint Sensor logs (on-prem)
        Copy-Item $localAgentPath\..\iService\iES\ESE\ESC_Logs\*.log client\iES
        Copy-Item $localAgentPath\..\iService\iES\ESE\debug\*.log client\iES
        Copy-Item $localAgentPath\..\iService\iES\ESE\debug\*.log.? client\iES
        Copy-Item $localAgentPath\..\iService\iES\ESE\module\2\*.db client\iES
        #get XDR logs (Vision One as a Service)
        Copy-Item "$localAgentPath\..\Endpoint Basecamp\log\*.log" client\EndpointBasecamp
        #get BM Logs (Behavior Monitoring)
        Copy-Item "$localAgentPath\..\BM\log\*.log" -Destination client\BM
        #get AOT logs
        Copy-Item "$localAgentPath\..\AOT\ASMMTemp\*.gz" -Destination client\AOT #Build 1021
        Copy-Item "$localAgentPath\..\AOT\ETWTemp\*.gz" -Destination client\AOT  #Build 1021
        #get Cloud Endpoint Logs
        Copy-Item "$env:programfiles\Trend Micro\Cloud Endpoint\modules\AuMgmtModule\iAUSDK\iaulogs\iau.log" -Destination client\CloudEndpoint #Build 1021
        Copy-Item "$env:programfiles\Trend Micro\Cloud Endpoint\modules\AuMgmtModule\iAUSDK\iaulogs\TmuDump.txt" -Destination client\CloudEndpoint #Build 1021

        Set-Location -Path 
        return "Success"
        }
    else { return "Failed" }

    }

########################################################################
# Get Trend Micro server log information
########################################################################
function fnGetServerInformation
{
param ( [string]$localServerPath, [string]$localWinDir, [string]$localOutputDir )

Write-Host "Retrieving server information..."
if (Test-Path $localServerPath) 
        { 
        #get directory listing
        Get-ChildItem $localServerPath -Recurse | Out-File server\dirlist.txt
        #get configuration files
        Copy-Item $localServerPath\ofcscan.ini -Destination server\ofscan.ini
        Copy-Item $localServerPath\ous.ini -Destination server\ous.ini
        Copy-Item $localServerPath\Admin\hotfix_history.ini -Destination server\hotfix_history.ini
        Copy-Item $localServerPath\Admin\ssnotify.ini -Destination server\ssnotify.ini
        Copy-Item $localServerPath\Private\ofcserver.ini -Destination server\
        Copy-Item $localServerPath\Private\dlp.ini -Destination server\
        Copy-Item $localServerPath\Private\DLP_exception.ini -Destination server\
        Copy-Item $localServerPath\Private\DLPForensicDataTracker.db -Destination server\
        #get log files
        Copy-Item $localWinDir\OFCMAS.LOG -Destination server\
        Copy-Item $Env:SystemDrive\TmPatch.log -Destination server\
        Copy-Item $localServerPath\..\Addon\TMSM\debug.log* -Destination server\TMSM
        Copy-Item $localServerPath\..\Addon\TMSM\*.ini -Destination server\TMSM
        Copy-Item $localServerPath\..\Addon\TMSM\AU_Data\AU_Log\TmuDump.txt -Destination server\TMSM
        Copy-Item $localServerPath\..\Addon\TMSM\TMSMMainService.InstallLog -Destination server\TMSM
        Copy-Item $localServerPath\..\Addon\TMSM\TMSMMainService.InstallState -Destination server\TMSM
        Copy-Item $localServerPath\..\Addon\TMSM\ServerInfo.plist -Destination server\TMSM
        Copy-Item $localServerPath\..\iServiceSvr\iES\*.log -Destination server\iES
        Copy-Item $localServerPath\..\iServiceSvr\iVP\*.log -Destination server\iVP
        Copy-Item $localServerPath\..\iServiceSrv\iVP\AU\release\bin\AU_Data\AU_Log\TmuDump.txt -Destination server\iVP
        Copy-Item $localServerPath\..\iServiceSrv\iATAS\ActiveUpdate\AU_Data\AU_Log\TmuDump.txt -Destination server\iATAS
        Copy-Item $localServerPath\..\iServiceSrv\iATAS\DebugLog\*.log -Destination server\iATAS

        Copy-Item $localServerPath\Web\Service\AU_Data\AU_Log\TmuDump.txt -Destination server\LWCS_TmuDump.txt
        Copy-Item $localServerPath\LWCS\access.log -Destination server\LWCS_access.log
        Copy-Item $localServerPath\LWCS\CCCADump.log -Destination server\LWCS_CCCADump.log
        Copy-Item $localServerPath\LWCS\diagnostic.log -Destination server\LWCS_diagnostic.log
        Copy-Item $localServerPath\WSS\access.log -Destination server\WSS_access.log
        Copy-Item $localServerPath\WSS\diagnostic.log -Destination server\WSS_diagnostic.log
        Copy-Item $localServerPath\*.log -Destination server\
        Copy-Item $localServerPath\Web\Service\diagnostic.log -Destination server\web_service_diagnostic.log
  
        Copy-Item $localServerPath\Web\Service\DwnldStat.log -Destination server\web_service_DwnldStat.log

        ####################################################################
        # Get web serer site identifier, dierctory, and last logs
        ####################################################################
        # make sure the IIS provider is loaded.
        Import-Module -Name WebAdministration
        # Get the site information of the OfficeScan web site (usually 3)
        $OSCEsite=(Get-ItemProperty -Path 'IIS:\Sites\OfficeScan' -Name id).value
        # Get directory location of the OfficeScan web site log files
        $IISLogdir=(Get-ItemProperty -Path 'IIS:\Sites\OfficeScan' -Name logfile).directory
        # Echo the OSCE full log directory path to variable, thus interpreting system tokens.
        # $OSCELogdir=cmd /c echo %SystemDrive%\inetpub\logs\LogFiles\w3svc3
        $OSCELogdir=cmd /c echo $IISLogdir\w3svc$OSCEsite
           
        if ( Test-Path $OSCELogdir ) 
            {
            Write-Host "Retrieving last 10 IIS logs..."
            Set-Location -Path $OSCELogdir
            Get-ChildItem -Name *.log | Select-Object -last 10 |Copy-Item -Destination $localOutputDir\server\IISLogs
            Set-Location -Path $localOutputDir
            }             #end if $OSCELogdir exists
 
        return "Success"
        }        #end if $LocalServerPath exists 
    else { return "Failed" }
}    #End function fnGetServerInformation

########################################################################
#Get version information from some important files in the client directory
########################################################################
function fnGetFileVersion
{
param ( [string]$localAgentPath )

Write-Host "Retrieving file version information..."
$VersionList = @("TmListen.exe","TmListen_64x.dll","pccntmon.exe","PccNTUpd.exe","upgrade.exe","tmbmsrv.exe","ntrtscan.exe","ccsf\tmccsf.exe","vsapi64.dll","vsapi32.dll","tmproxy.exe","tmpfw.exe","pccntupd.exe","cntaosmgr.exe","ntrmv.exe","ofcpfwsvc.exe","tsc.exe","tsc64.exe","patch.exe","patch64.exe","vsencode.exe","flowcontrol.dll","flowcontrol_64x.dll","libcntprodres_64x.dll","ofcpipc.dll","ofcpipc_64x.dll","ofcpluginapi_64x.dll","perficrcperfmonmgr.dll","libnetctrl_64x.dll","libtmcav_64x.dll","loadhttp_64x.dll","pccwfwmo.dll","pccwfwmo_64x.dll","tmlistenshare_64x.dll","tmpac_64x.dll","tmsock_64x.dll","WofieLauncher.exe","CCSF\TmCCSF.exe")

foreach ( $filename in $VersionList )
    {
    if ( Test-Path "$AgentPath\$filename" )
        {
        # Out-File -FilePath ".\$MyOutputName" -Encodeing ASCII "$filename, " -NoNewline
        $FileVersion = (Get-Item "$localAgentPath\$filename").VersionInfo.FileVersion
        Out-File -FilePath "client\FileVersion.csv" -Encoding ASCII -Append -InputObject "$filename, $Fileversion"
        }
    else { Out-File -FilePath "client\FileVersion.csv" -Encoding ascii -Append -InputObject "$filename, does not exist." }
    }
}

########################################################################
#Get SHA256 of collected files
######################################################################## 
function fnGetSHA256
{
param ( [string]$localOutputName )
Get-ChildItem -Recurse -Path $localOutputName | Get-FileHash -Algorithm SHA256 | Export-Csv -NoTypeInformation "FileIndexList.csv"
Move-Item -Path "FileIndexList.csv" -Destination "$localOutputName"
}

########################################################################
# Configure script operation
########################################################################
$ErrorActionPreference = 'SilentlyContinue'
#Requires -RunAsAdministrator


########################################################################
#Get environment variables
########################################################################
# $MyStartDir = (Get-Item .).FullName
$MyDateTime =  get-date -format "yyyyMMdd_HHmmss"
$MyComputerName = $Env:COMPUTERNAME
# $IISsiteID = Get-IISSite -Name OfficeScan |select -ExpandProperty id
$IISLogdir=(Get-ItemProperty -Path 'IIS:\Sites\OfficeScan' -Name logfile).directory

$MyTempDir = Get-Location
$SystemRoot = $Env:SystemRoot
$MyWinDir = $Env:windir
$TempDir = $Env:TEMP
$AgentPath =  (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion -Name "Application Path")."Application Path"
$ServerPath =  (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\OfficeScan\service\Information -Name "Local_Path")."Local_Path"
$ServerAddr = (Get-ItemProperty -Path Registry::\HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\TrendMicro\PC-cillinNTCorp\CurrentVersion -Name "Server")."Server"
$MyOutputName = "$TempDir\$MyComputerName-$MyDateTime"
$ProgramName = $MyInvocation.MyCommand.Name
$ProgramVersion = '3.3'
$ProgramBuild = '1021'

fnCreateOutputDirectory -MyOutputDir "$MyOutputName"
write-output "Program Name: $ProgramName`nProgram Version: $ProgramVersion`nBuild Number: $ProgramBuild" | out-file -FilePath $MyOutputName\ProgramInfo.txt -Encoding ascii -force

Set-Location -Path $MyOutputName
fnGetBasicSystemInfo -LocalWinDir "$MyWinDir"
Test-NetConnection -TraceRoute "$ServerAddr" | Out-File -FilePath traceroute.txt
fnGetFileVersion -localAgentPath $AgentPath
fnGetRegistries
fnGetWindowsEventLogs

if ( $AgentPath -ne $null )
    { $MyGetClientInfoStatus = fnGetClientInfo -localAgentPath $AgentPath -localWinDir $MyWinDir -localTempDir $TempDir -localOutputDir $MyOutputName }

if ( $ServerPath -ne $null )
    { $MyGetServerInfoStatus = fnGetServerInformation -localServerPath $ServerPath -localWinDir $MyWinDir -localOutputDir $MyOutputName }

Write-Host ""
Write-Host "Client Information Status: $MyGetClientInfoStatus"
Write-Host "Server Information Status: $MyGetServerInfoStatus"
Write-Host ""

Set-Location -Path $TempDir
fnGetSHA256 -localOutputname $MyOutputName

Write-Host "Compressing output..."
& $AgentPath\7z.exe a -ptrend -tzip "$MyOutputName.zip" "$MyOutputName"

# $MyCWD = (get-item .).FullName
Write-Host "Output File Location:`t$MyOutputName.zip"

return
