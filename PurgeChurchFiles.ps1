<#
    .SYNOPSIS
    A quick PowerShell script to purge files from a given directory.

    .DESCRIPTION
    This script reads the given directory and then deletes the files and folders that are older
    than the provided file age, default is 30 days.  It then reads the given directory for other
    sub-directories and removes any directory not modified in time period given in the file age.

    I provided an array within the script, $defaultExcludes, for files and directories to
    always exclude. Include in the $MyExcludes parameter the additional files and directories you wish 
    to skip during recursive remove process.

    .PARAMETER Path
    The fully qualified or relative path name of a directory to be purged.  The path 
    may either be a fully qualified path name, C:\users\username\downloads\ or a relative path 
    name, ~\downloads\.  Be sure to include the trailing slash.

    .PARAMETER MyExcludes
    The MyExcludes parameter is an arry of strings.  These are the directories to ignore so they are not 
    deleted. The format for this parameter is a list of string values, enclosed in quotes, separated by a comma.
    Example: -MyExcludes "dir1","dir2"

    .PARAMETER FileAge
    The maximum number of days to keep a file or directory.  The default is 30, meaning all files
    and directories not modified in the past 30 days will be removed, unless a directory exclusion
    was added. Example: -FileAge 60.

    .PARAMETER WhatIf
    The WhatIf switch allows you to run the command without taking any action.  The output shows you
    what would have happened if you executed the script.  This is good way to make sure you get the 
    desired results before removing files and directories. Example: -WhatIf

    .EXAMPLE
    PS> ./PurgeChurchFiles.ps1
    #Run the script with default settings; delete files and sub-folders in the defualt directory older than 30 days old.

    .EXAMPLE
    PS C:\Users\username\src\ps1> .\PurgeChurchFiles.ps1 -Path C:\inetpub\wwwroot\ -FileAge 7 -WhatIf
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\Click-it.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\favicon.ico".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\ggeen-menu.css".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\index.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\MenuPlanner.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\program.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\resource.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\todolist.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\TrendBrand2023.css".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\BlogShorts".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\Commands".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\gov".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\images".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\Recipes".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\test".
    PS C:\Users\username\src\ps1>
    
    .EXAMPLE
    PS> ./PurgeChurchFiles.ps1 -Path ~\Downloads
    #Purge the relative path name and sub-directories older than 30 days.

    .EXAMPLE
    PS C:\Users\username\src\ps1> .\PurgeChurchFiles.ps1 -Path C:\inetpub\wwwroot\ -MyExcludes "*.css","*.ico" -FileAge 7 -WhatIf
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\Click-it.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\index.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\MenuPlanner.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\program.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\resource.html".
    What if: Performing the operation "Remove File" on target "C:\inetpub\wwwroot\todolist.html".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\BlockThisFolder".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\BlogShorts".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\Commands".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\images".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\Recipes".
    What if: Performing the operation "Remove Directory" on target "C:\inetpub\wwwroot\test".
PS C:\Users\username\src\ps1> 
    .NOTES
    Author: G D Geen
    Date-written: 3 Jul 2025
#>

param (
    [string] $Path = $env:homedrive+$env:homepath+"\downloads",
    [string[]] $MyExcludes,
    [int] $FileAge=30,
    [switch] $WhatIf
)

Set-Variable Version -Option Constant -Value "1.0.0003"
Set-Variable ProgramPublished -Option Constant -Value "10 Jul 2025"
$defaultExlcudes = @("desktop.ini","BlockThisFolder")
$allExcludes = @()
$AnchorDate=(get-date).AddDays(-$FileAge) #get today's date and subtract the value of $FileAge.
# $MyExcludes=@('gov','BlogShorts') #Array of directories to exclude from get-childitem collection.

$allExcludes = $($defaultExlcudes; $MyExcludes) #combine defaultExcludes and MyExcludes arrays into a single array.

Write-output "$PSCommandPath `nVersion: $Version`nGA Date: $ProgramPublished`n"
Write-output "Removing files older than $FileAge days ($AnchorDAte) in: $Path"

if($WhatIf) {
  get-childitem -path $Path\* -exclude $allExcludes -file |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -whatif
  get-childitem -path $Path -exclude $allExcludes -directory |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -recurse -whatif
}
else {
  get-childitem -path $Path\* -exclude $allExcludes -file |where-object {$_.CreationTime -lt $AnchorDate} | remove-item
  get-childitem -path $Path -exclude $allExcludes -directory |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -recurse
}

#get directory names from the given path, exluding those I dont want delete, recursively remove the directory and its contents (-whatif ) 
#get-childitem -path ./wwwroot -exclude BlogShorts -directory | remove-item -recurse -whatif
#get-childitem -path $Path -recurse -force -file -filter *.log |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -whatif

