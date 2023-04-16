#!/usr/bin/env bash

# simple script to setup a Radio Free Fedi streamer on a Raspberry Pi or similar

echo "updating and installing required packages"
# update to latest packages all around
apt-get update -qq && apt-get upgrade -y

# install mplayer and unattended-upgrades packages
apt-get install -y mplayer unattended-upgrades


# set Radio Free Fedi mp3 stream URL:
echo "setting up Radio Free Fedi stream URL"
if [ -n "${1}" ]; then
    radio_url="${1}"
else
    radio_url="http://217.20.116.68:8055/comfy"
fi
echo "RFF stream URL set to: ${radio_url}"

# setup RFF SystemD service
echo "setting up RFF radio SystemD service"
tee > /etc/systemd/system/radio.service << EOF
[Unit]
Description=Radio Free Fedi service

[Service]
ExecStartPre=/usr/bin/sleep 15
ExecStart=/usr/bin/mplayer -quiet ${radio_url}

[Install]
WantedBy=multi-user.target
EOF

chmod 664 /etc/systemd/system/radio.service
systemctl daemon-reload
systemctl enable radio.service
systemctl start radio.service


# set volume level
echo "setting volume level"
amixer -M sset PCM 80%


# Configure automatic security updates
echo "setting unattended security updates"
tee > /etc/apt/apt.conf.d/50unattended-upgrades <<EOF
Unattended-Upgrade::Allowed-Origins {
    "\${distro_id}:\${distro_codename}-security";
};
Unattended-Upgrade::Package-Blacklist {
};
Unattended-Upgrade::MinimalSteps "true";
Unattended-Upgrade::Automatic-Reboot "false";
EOF

echo "all done!"
