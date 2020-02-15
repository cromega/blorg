---
author: cromega
layout: post
title: ezdrummer 2 on linux
date: Sun Feb 09 14:25:12 UTC 2020
tags: [geek]
---

This is not a copy and paste into terminal solution. There are some moving parts, some manual steps and you may have to customise some of this stuff to make it suit your needs.

<!-- more -->

## The circumstances:

* 64-bit OS
* Linux Mint 19.3 (Ubuntu 18.04 based)
* EZdrummer 2 64-bit

NOTE on 32 vs. 64-bit: There is a bug in the 64bit EZD installer I will mention later so using the 32-bit version would be better, however it would need a 32-bit WineASIO driver which is a pain when your host OS is 64-bit.

In order to get it to work we need the following:

* Wine
* Wineasio
* Jack 2
* EZdrummer 2

## Wine

On my 18.04 based system Wine 3.0 seems to be the latest stable version, which may actually work flawlessy for EZD. I added the winehq repository to have access to Wine 4.0. You also need some extra packages for compiling DLLs.

Install the following packages:

* If using standard wine packages: `wine-stable wine64-tools`
* If using winehq: `winehq-stable libwine-dev`

Create a Wine environment if you don't have one already

```sh
# create a wine cellar (seriously, it's called a wine cellar)
winecfg # you can close it straight away

```

## WineASIO

WineASIO is a driver that exports an ASIO interface in Wine and acts as a client to Jack on the host OS.

Install the following packages:

```
sudo apt-get install libwine-dev libjack-jackd2-dev
```

Versions as of the time of writing:

* Wineasio 0.9.2 (it's from 2013 so I don't think it will change any time soon)
* ASIO 2.3 headers

We need the source code of wineasio: <https://sourceforge.net/projects/wineasio/files/wineasio-0.9.2.tar.gz/download>

And the official asio headers, which can't be packaged because of licensing misery. You can grab the official ASIO SDK or any copy of the headers you find. I used this: <https://github.com/thestk/rtaudio/blob/master/include/asio.h>


```sh
tar -xzf wineasio-0.9.2
cd wineasio-0.9.2
cp ../asio.h . # or wherever you saved the headers
./prepare_64bit_asio
make -f Makefile64
```

If it all worked fine you should have a `wineasio.dll.so` file in the folder. Now you need to register it with Wine.

```sh
sudo cp wineasio.dll.so /opt/wine-stable/lib64/wine/
wine64 regsvr32 wineasio.dll
# regsvr32: Successfully registered DLL 'wineasio.dll'
```

## Jack

```sh
apt-get install jackd2
```

If the installer asks you if you want to enable realtime system configuration, say yes. You also need to add your user to the `audio` group if it's not in it already.

```
sudo gpasswd -a $USER audio
```

Check `/etc/security/limits.d/audio.conf`: I'm a bit wary of letting Jack use unlimited shared memory so I limited memlock to 2gb

```
@audio   -  memlock   2097152
```

Reboot your system to make these changes take effect.

There are 2 packages to make life easier:

* `qjackctl`: A small GUI to start/stop the Jack server and to optimize the parameters (buffer size, etc). I'm afraid you'll have to figure this bit out yourself because it depends on your system and use-case.
* `pulseaudio-module-jack`: Jack hooks ALSA exclusively so nothing else will be able to use the audio output while it is running. This package installs a sink for Pulseaudio so it can use Jack as its output. This way pretty much everything should be able to make a noise when Jack is running. You have to select Jack as the main audio output when the Jack server is running.

## EZdrummer 2

Now on to the fun part. (No, this is pretty crappy actually)

Download and extract the Toontrack product downloader/updater tool somewhere and execute it.

```
wine64 Toontrack\ Product\ Manager\ Installer.exe
```

Install EZdrummer 2 64-bit (don't update) and all the EZX'es you have.

Now the shitty bit. The 64-bit udpater doesn't work. It won't find the software already installed. I think it's down to msiexec not looking in the right folder but I didn't have the mental and spiritual capacity to look into it in more detail.

I copied over the EZD files from a fully updated installation I made using Windows.


The Wine installation is located under `~/.wine/drive_c` and the folders you need to sync over from the mounted Windows partition are:

* `/mnt/windows/Program Files (x86)/Common Files/Toontractk/EZDrummer`
* `/mnt/windows/Program Files/Toontrack/EZdrummer`
* `/mnt/windows/ProgramData/Toontrack/EZdrummer`
* `/mnt/windows/Program Files/Common Files/VST3/Toontrack`

Now, make sure the Jack server is running and launch EZD.

```sh
wine64 .wine/drive_c/Program\ Files/Toontrack/EZdrummer/EZdrummer64.exe
```

If everything's fine it shouldn't complain about updates you need to install for the audio/midi library. The about window should say: `Standalone host version 2.1.8`

On the sound configuration panel you should be able to select WineASIO.

You won't be able to use the Toontrack updater as it has no idea what versions are installed. If Toontrack releases an update you need to install it under Windows and sync over the changes again. I may update this article if I find a way around this issue (either by making the updater work or by compiling a 32-bit wineasio driver)
