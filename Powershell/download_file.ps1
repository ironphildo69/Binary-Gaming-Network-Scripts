$url = "https://source"
$output = "destination"

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($url, $output)