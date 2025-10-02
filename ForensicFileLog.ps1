<#
    .SYNOPSIS
    A quick PowerShell script to log the file access date and time.

    .DESCRIPTION
    The script reads the directory file list storing the full path name to the file,
    the creation time, last write time, and last access time.  This information is then
    logged to the console screen.  The user may pass any accessable file/directory path, 
    and may request a recursive read of the directory structure.  The default settings are 
    a non-recursive logging of the current working directory.

    .PARAMETER Path
    The fully qualified or relative path name of a file or directory to be logged.

    .PARAMETER Recurse
    Command line switch requesting the script to recursively log the provided path name.

    .EXAMPLE
    PS> ./FileAccessLog.ps1                 
    #Run the script with default settings; current working direcotry and non-recursive logging.  

    .EXAMPLE
    PS> ./FileAccessLog.ps1 -Path c:\users\Foo      
    #Log the absolute path of C:\users\Foo

    .EXAMPLE
    PS> ./FileAccessLog.ps1 -Path ~\Downloads       
    #Log the relative path name for the current logged in users Downloads directory

    .EXAMPLE
    PS> ./FileAccessLog.ps1 -Path C:\Windows\Temp -Recurse      
    #Log the contents of the Windows\Temp directory and recurse through all subdirectories

    .NOTES
    Author: G D Geen
    

#>

Param(
    [string]$Path = ".\",
    [switch]$Recurse
)

$TimeStamp = get-date -uformat "%m/%d/%Y %T"
if ($Recurse) { $Myfilepath = (get-childitem $Path -Recurse |Select-Object fullname,CreationTime,LastWriteTime,LastAccessTime) }
else { $Myfilepath = (get-childitem $Path |Select-Object fullname,CreationTime,LastWriteTime,LastAccessTime) }

"Command Run at: "+$TimeStamp
$Myfilepath | ConvertTo-Csv

