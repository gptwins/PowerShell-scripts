param (
	[string]$Path = $env:homedrive+$env:homepath,
	[int32]$Seconds = 600,
	[string]$Logfile = ""
	)

$ErrorActionPreference = 'SilentlyContinue'
$pics = Get-ChildItem $Path/*.png,$Path/*.jpg,$Path/*.jpeg,$Path/*.gif,$Path/*.jiff -name
$sizeOfPics = @($pics).Length
write-host("Total number of slides: $sizeOfPics")

for( $i=0; $i -lt $sizeOfPics; $i++){
	$TimeStamp = (Get-Date).toString("yyyy/MM/dd, HH:mm:ss")
	$photo = Get-Random $pics
	<# if ( (Test-path -Path $photo -PathType Leaf) ) { 
		write-host($photo)		
	} #>
		if ( $Logfile -eq "" ) { write-host("$TimeStamp, $photo")}
		else { 
			Add-Content -Path $Logfile -value "$TimeStamp, $photo"
		}
	start-process -FilePath $Path\$photo
	start-sleep -seconds $Seconds

	$OSver = (Get-WmiObject -class Win32_OperatingSystem).Caption
	switch ($OSver) {
		"Microsoft Windows 11" {
			stop-process -name "PhotosApp" 
			start-sleep -seconds 3
		}
		"Microsoft Windows 11 Pro" {
			stop-process -name "photos"
			start-sleep -seconds 3
		}
		"Microsoft Windows 11 Enterprise" {
			stop-process -name "photos"
			start-sleep -seconds 3
		}
		* {
			stop-process -name "Microsoft.Photos"
			start-sleep -seconds 3
		}
	}
	
	
}

<# 
foreach( $photo in $pics) {
$photo = get-random $pics
write-host($photo)
start-process $Path/$photo
start-sleep -seconds $Seconds
stop-process -name "Microsoft.Photos"
}
#>