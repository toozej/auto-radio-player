# rff-auto-player


## Intro
Radio Free Fedi Auto Player is a quick and simple script to install a SystemD service unit for automatically playing the [Radio Free Fedi "Comfy" mp3 stream](https://radiofreefedi.net/) on system startup.

In particular this service was designed to be ran headlessly on a Raspberry Pi running a Debian-based distro, and outputting audio to the 3.5mm aux jack. And since it is designed to be ran headlessly, automatic unattended security updates are also enabled.

If one so desired, this setup could be adjusted to play any other audio file or stream by passing an argument ${1} to the `install.sh` script.


## Pre-reqs
- Some kind of Debian-based distro using SystemD
- `bash` and `curl`
- `sudo` or root permissions


## Installation and Usage

One-liner if you like to live dangerously:
```bash
curl -s -L https://github.com/toozej/rff-auto-player/blob/main/install.sh | sudo bash
```

If you'd like to use a different radio station (or file):
```bash
curl -s -L https://github.com/toozej/rff-auto-player/blob/main/install.sh | sudo bash -s AUDIO_FILE_OR_STREAM_GOES_HERE
```

If you prefer git:
```bash
git clone git@github.com:toozej/rff-auto-player.git
sudo ./rff-auto-player/install.sh
```
