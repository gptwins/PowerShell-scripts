
<#
    .SYNOPSIS
    A quick powershell script display the system uptime in years, months,
    days, hours, minutes, and seconds.

    .DESCRIPTION
    The script displays the systems name, current system date and time and,
    finally, the system uptime in Years, Months, Days, Hours, Minutes, and Seconds.
    This is useful during incident response/Forensic investigation to determin
    if the system was restarted.  The computer name and current system time are
    good practice, forensically, to identify the evidence and to determine the 
    amount of time drift may have occurred.

    Forensically, the output should be saved to a file and HASHed as evidence
    collection best practice.

    .EXAMPLE
    PS> ./System-Uptime.ps1
    Host Name:  YYYY-XXXXXXX
    Current date/time:  11/7/2024 8:58:00 AM
    Uptime:


    Years        :
    Months       :
    Days         : 1
    Hours        : 20
    Minutes      : 36
    Seconds      : 55
    Milliseconds : 641

    PS>

    .NOTES
    Author: G D Geen
#>

write-host "Host Name: "$env:COMPUTERNAME
write-host "Current date/time: " (get-date)
write-host "Uptime: "
(get-date) - (gcim Win32_OperatingSystem).LastBootUpTime | select-object Years,Months,Days,Hours,Minutes,Seconds,Milliseconds