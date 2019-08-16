##Phillip Inman
#Binary Gaming Network
#Version 1.1 - 07/01/2018

##Global Vars

#Where you want the game server to install to, by default it puts it in the same directory as the steamcmd folder
$gameServerDir = "game_server"
#Login details for those pain in the ass game servers that require login
$login = "anonymous"
#filename of powershell core version to retrevive, doesnt have a /latest link which is a pain
$powershellCoreVersion = "PowerShell-6.1.1-win-x64.msi"
#Game ID that you want to download and install, google helps here
$gameid = "346110"
#An array of Mod IDs that are fed in one by one, allows steamcmd to singularly download them. this is to work around a limitation of steamCMD. Its clean and works.
$modids = @(
    "1595131090")
#Where do you want to mods to go? Put the folders here.
$modDestination = "./destination"
##Support Functions - Pre Script

#Ensures the installed powershell version is above 5.
function getPowershellVersion {

    $version = $PSVersionTable.psversion.Major

    if ($version -ge "6") {
        Write-Output "Powershell Core is installed!"
        }
    elseif ($version -lt "6") {
        Write-Output "Powershell Core is not installed! Installing..."
        installPowerShellCore
        }
    else {
        Write-Output "There was an error detecting your powershell version! It may be Disabled. Terminating Script..."
        exit
        }
}

function installPowerShellCore {
    $url = "https://github.com/PowerShell/PowerShell/releases/download/v6.1.1/$powershellCoreVersion"
    $savepath = "./$powershellCoreVersion"
    [Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
    Invoke-WebRequest -Uri $url -OutFile $savepath
    Start-Process -FilePath "./$powershellCoreVersion" -ArgumentList "/passive" -Wait
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

#Gets the SteamCMD files using Invoke-Webrequest. HTTP transfer is decent enough for this.
function installSteamCMD {
    $url = "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip"
    $savepath = "./steamcmd.zip"
    $extractpath = "./steamcmd/"
    Invoke-WebRequest -Uri $url -OutFile $savepath
    Expand-Archive -Path $savepath -DestinationPath $extractpath
    Start-Process -FilePath "./steamcmd/steamcmd.exe" -WorkingDirectory ./steamcmd/ -ArgumentList "+quit" -Wait -NoNewWindow
}

##Functions relationt to Getting and Installing the GameServer

function downloadGame {
    Start-Process -FilePath "./steamcmd/steamcmd.exe" -WorkingDirectory "./steamcmd/" -ArgumentList " +login $login +force_install_dir ../$gameServerDir +app_update $gameid validate +quit" -Wait -NoNewWindow
}

##Game Specific Functions

#Gets mods for ARK by calling a 3rd party script.

function getMods {
    foreach($modid in $modids) {
        Start-Process -FilePath "./steamcmd/steamcmd.exe" -WorkingDirectory "$(Get-Location)" -ArgumentList "+login $login +workshop_download_item $gameid $modid  +quit" -NoNewWindow -Wait
        Copy-Item -Path "$(Get-Location)\steamcmd\steamapps\workshop\content\$gameid\$modid" -Destination $modDestination -Force -Recurse
    }
}

##Logic

getPowershellVersion
getSteamCMDStatus
downloadGame
getMods
