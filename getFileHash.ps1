<#
    .SYNOPSIS
    A quick PowerShell script to log the file size and SHA-256 value.

    .DESCRIPTION
    The script reads the requested directory, current directory by default, and stores the 
	fully qualified file path/name and file size in bytes.  It then calculates the 
	SHA-256 HASH value.  The output is written to the screen with the date and time
	the command was run.

    .PARAMETER Path
    The fully qualified or relative path name of a file or directory to be logged.

    .PARAMETER Recurse
    Command line switch requesting the script to recursively log the provided path name.

    .EXAMPLE
    PS> ./getFileHash.ps1                 
    #Run the script with default settings; current working direcotry and non-recursive logging.  

    .EXAMPLE
    PS> ./getFileHash.ps1 -Path c:\users\Foo      
    #Log the absolute path of C:\users\Foo

    .EXAMPLE
    PS> ./getFileHash.ps1 -Path ~\Downloads       
    #Log the relative path name for the current logged in users Downloads directory

    .EXAMPLE
    PS> ./getFileHash.ps1 -Path C:\Windows\Temp -Recurse      
    #Log the contents of the Windows\Temp directory and recurse through all subdirectories

    .NOTES
    Author: G D Geen
    

#>

param (
	[string]$Path = "./",
	[switch]$Recurse
)

$TimeStamp = get-date -uformat "%m/%d/%Y %T"
write-host "Command Run at: "$TimeStamp",,"
write-host "Full path name,file size,SHA-256 value"

if($Recurse) { $filelist = @(get-childitem -Path $Path -Recurse -file) }
else { $filelist = @(get-childitem -Path $Path -file) }

foreach($file in $filelist) {
	$filehash = get-filehash -path $file.fullname -algorithm sha256 | select-object hash
	$fileDetail = '"'+$file.fullname+'"'+","+$file.length+","+$filehash
	write-host $fileDetail
}