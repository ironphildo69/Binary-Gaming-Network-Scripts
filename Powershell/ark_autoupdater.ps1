##Phillip Inman
#Binary Gaming Network
#Version 1.1 - 07/01/2018

##Global Vars

$gameid = "346110"

$modids = @(
    "1252358730")

##Support Functions - Pre Script

#Ensures the installed powershell version is above 5.
function getPowershellVersion {

    $version = $PSVersionTable.psversion.Major

    if ($version -ge "5") {
        Write-Output "Powershell is up to date!"
        }
    elseif ($version -lt "5") {
        Write-Output "Powershell is not up to date! Installing..."
        }
    else {
        Write-Output "There was an error detecting your powershell version! It may be Disabled. Terminating Script..."
        exit
        }
}

#Parent function to see if steamcmd is locally installed to the scripts working directory. If not it will then call the installSteamCMD to download the nessisary files. 
function getSteamCMDStatus {
    $isInstalled = Test-Path -Path "$(Get-Location)\steamcmd\steamcmd.exe"
    if ($isInstalled -eq "true") {
        Write-Output "SteamCMD Found! Skipping Install..."
    }
    else {
        Write-Output "SteamCMD not found! Starting Download..."
        installSteamCMD
    }
}

#Gets the SteamCMD files using BITS. BITS must be installed for this to work but to be fair it is a windows default.
function installSteamCMD {
    $url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
    $savepath = "./steamcmd.zip"
    $extractpath = "./steamcmd/"
    Start-BitsTransfer -Source $url -Destination $savepath
    Expand-Archive -Path $savepath -DestinationPath $extractpath
    Start-Process -FilePath "./steamcmd/steamcmd.exe" -WorkingDirectory ./steamcmd/ -ArgumentList "+quit" -Wait
}

##Functions relationt to Getting and Installing the GameServer

function downloadGame {
    Start-Process -FilePath "./steamcmd/steamcmd.exe" -WorkingDirectory "./steamcmd/" -ArgumentList " +login anonymous +force_install_dir ../game_server +app_update $gameid validate +quit" -Wait
}

##Game Specific Functions

#Gets mods for ARK by calling a 3rd party script.

function getMods {
    foreach($modid in $modids) {
        #Start-Process python -WorkingDirectory "$(Get-Location)\MAPNAME\Ark\ShooterGame\Content\Mods\" -ArgumentList ""
        Start-Process -FilePath "./steamcmd/steamcmd.exe" -WorkingDirectory "$(Get-Location)\test\" -ArgumentList "+login anonymous +workshop_download_item $gameid $modid  +quit"
        Copy-Item -Path "C:\Users\phillipi\Downloads\steamcmd\steamapps\workshop\content\$gameid\$modid" -Destination "./test" -Force -Recurse
        extractMods
    }
}

function extractMods {
    Get-ChildItem -Path "./test" -Recurse -Filter *.z |
    ForEach-Object {
        Write-Output "eyy boi"
        Start-Process python -WorkingDirectory "$(Get-Location)\test\" -ArgumentList ""
    }
}
##Logic

getSteamCMDStatus
downloadGame
getMods
#extractMods
