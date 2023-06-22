# auto-radio-player


## Intro
Auto Radio Player is a quick and simple script to install a SystemD service unit for automatically playing a variety of Internet radio stations on system startup and rotating daily.

In particular this service was designed to be ran headlessly on a Raspberry Pi running a modern Debian-based distro (Debian Bookworm or newer), and outputting audio to the 3.5mm aux jack. And since it is designed to be ran headlessly, automatic unattended updates with automatic reboots are also enabled.

Radio stations pre-installed:
- [Radio Free Fedi "Comfy" mp3 stream](https://radiofreefedi.net/)
- [SomaFM stations in highest AAC quality](https://somafm.com/listen/)

If one so desired, this setup could be adjusted to play any other audio file or stream by passing an argument ${1} to the `install.sh` script.


## Pre-reqs
- Some kind of Debian-based distro using SystemD (Raspberry Pi OS works great on RPi)
- `bash` and `curl`
- `sudo` or root permissions


## Installation and Usage

One-liner if you like to live dangerously:
```bash
curl -s -L https://raw.githubusercontent.com/toozej/auto-radio-player/main/install.sh | sudo bash
```

If you'd like to use a different radio station (or file):
```bash
curl -s -L https://raw.githubusercontent.com/toozej/auto-radio-player/main/install.sh | sudo bash -s AUDIO_FILE_OR_STREAM_GOES_HERE
```

If you prefer git:
```bash
git clone git@github.com:toozej/auto-radio-player.git
sudo ./auto-radio-player/install.sh
```
