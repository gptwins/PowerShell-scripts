<#
    .SYNOPSIS
    A quick PowerShell script to purge files from a given directory.

    .DESCRIPTION
    This script reads the given directory and then deletes the files that are older
    than the provided file age, default is 30 days.  It then reads the given directory for other
    sub-directories and removes any directory not modified in time period given in the file age.

    I provided an array within the script for directory exclustions.  Include in the $MyExcludes
    the directories you wish to skip during recursive remove process.

    .PARAMETER Path
    The fully qualified or relative path name of a file or directory to be logged.  The path may either 
    be a fully qualified path name, C:\users\glen\downloads or a relative path name, ~\downloads.

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
    PS> ./PurgeChurchfiles.ps1 -Path c:\users\Foo
    #Purge the bsolute path of C:\users\Foo of files and folders older than 30 days.

    .EXAMPLE
    PS> ./PurgeChurchFiles.ps1 -Path ~\Downloads
    #Purge the relative path name and sub-directories older than 30 days.

    .EXAMPLE
    PS> ./PurgeChurchFiles.ps1 -Path C:\Windows\Temp -MyExcludes "My Assets","Keep Folder" -FileAge 90
    #Deletes all files and folders in C:\windows\Temp older than 90 days except the sub-directorires "My Assets" and "Keep Folder".  These
    #sub-directories are skipped during the deletion process.

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

$Version = "1.0.0001"
$AnchorDate=(get-date).AddDays(-$FileAge) #get today's date and subtract the value of $FileAge.
# $MyExcludes=@('gov','BlogShorts') #Array of directories to exclude from get-childitem collection.

if($WhatIf) {
  get-childitem -path $Path -file |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -whatif
  get-childitem -path $Path -exclude $MyExcludes -directory |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -recurse -whatif
}
else {
    get-childitem -path $Path -file |where-object {$_.CreationTime -lt $AnchorDate}
    get-childitem -path $Path -exclude $MyExcludes -directory |where-object {$_.CreationTime -lt $AnchorDate}
}

#get directory names from the given path, exluding those I dont want delete, recursively remove the directory and its contents (-whatif ) 
#get-childitem -path ./wwwroot -exclude BlogShorts -directory | remove-item -recurse -whatif
#get-childitem -path $Path -recurse -force -file -filter *.log |where-object {$_.CreationTime -lt $AnchorDate} | remove-item -whatif

