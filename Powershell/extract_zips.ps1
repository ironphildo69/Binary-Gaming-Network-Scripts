$BackUpPath = “source.zip”

$Destination = "destination"

Add-Type -assembly “system.io.compression.filesystem”

[io.compression.zipfile]::ExtractToDirectory($BackUpPath, $destination)