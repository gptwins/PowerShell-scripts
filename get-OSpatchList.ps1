<#
    .SYNOPSIS
    A quick powershell script display the system patches in table format.

    .DESCRIPTION
    The script executes the get-computerinfo PowerShell applet and outputs
    the computer name, operating system name, operating system build number,
    and HotFix IDs installed, in tabular format.

    .EXAMPLE
    PS> ./get-OSpatchList.ps1
    
    CsName       OsName                          OsBuildNumber HotFixID
    ------       ------                          ------------- --------
    NABU-2FGGNN3 Microsoft Windows 11 Enterprise 22631         KB5045935
    NABU-2FGGNN3 Microsoft Windows 11 Enterprise 22631         KB5019178
    NABU-2FGGNN3 Microsoft Windows 11 Enterprise 22631         KB5027397
    NABU-2FGGNN3 Microsoft Windows 11 Enterprise 22631         KB5036212
    NABU-2FGGNN3 Microsoft Windows 11 Enterprise 22631         KB5046633
    NABU-2FGGNN3 Microsoft Windows 11 Enterprise 22631         KB5044620
    PS>

    .NOTES
    Author: G D Geen
#>
Get-ComputerInfo | select-object csName, osname, osbuildnumber, oshotfixes  -ExpandProperty oshotfixes | select-object csname,osname,osbuildnumber,hotfixid | Format-table