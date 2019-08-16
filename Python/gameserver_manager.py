#!/usr/bin/python3

import os
import urllib
import tarfile
import subprocess

LOGON = "anonymous"
BRANCH = "public"
GAMEID = 0
GAMENAME = "game"

def doesVersionFileExist(basepath):
    gamename_path = '{}{}{}'.format(basepath, os.sep, GAMENAME)
    print(gamename_path)

    if os.path.exists("{}{}version".format(basepath, os.sep)):
        print("Version File Found!")
    else:
        print("Version file does not exist! Creating...")
        with open('version', 'w') as f:
            f.write(0)


def isSteamCMDInstalled(basepath):
    if os.path.exists("{base}{sep}steamcmd{sep}steamcmd.sh".format(
                                                        base=basepath,
                                                        sep=os.sep)):
        print("SteamCMD Found!")
    else:
        print("SteamCMD is not installed, downloading...")
        urllib.request.urlretrieve(
            "https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz",
            "./steamcmd.tar.gz"
        )

        tar = tarfile.open("./steamcmd.tar.gz", "r")
        tar.extractall("./steamcmd")
        print("{base}{sep}steamcmd{sep}steamcmd.sh".format(
            base=basepath,
            sep=os.sep
        ))

def getGameServerUpdate(basepath):

    output = subprocess.run(basepath + "/steamcmd/steamcmd.sh")
    print(output)

def getModUpdates(basepath):
    pass

def main():
    basepath = os.path.abspath(
        os.path.join(
            os.sep,
            os.getcwd()
        )
    )

    doesVersionFileExist(basepath)
    isSteamCMDInstalled(basepath)
    getGameServerUpdate(basepath)
    getModUpdates(basepath)

if __name__ == "__main__":
    main()
