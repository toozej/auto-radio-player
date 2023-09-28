#!/usr/bin/env bash

# simple script to setup an automatic radio streamer on a Raspberry Pi or similar

echo "updating and installing required packages"
# update to latest packages all around
apt-get update -qq && apt-get upgrade -y

# install required packages
apt-get install -y mplayer unattended-upgrades curl jq


# set radio stream URLs list:
echo "setting up list of radio stream URLs"
radio_conf="/etc/radio.conf"
rm -f "${radio_conf}" && touch "${radio_conf}"
chmod 0644 "${radio_conf}"
if [ -n "${1}" ]; then
    for arg in "$@"; do
        echo "${arg}" >> "${radio_conf}"
    done
else
    # append SomaFM music channels
    somafm_channels=$(curl -s -H 'Accept: application/json' https://somafm.com/channels.json | jq -r ".channels | map(select(.genre != \"spoken\" and (.genre | test(\"news\"; \"i\") | not))) | .[]" | jq -r ".playlists | map(select(.quality == \"highest\" and .format == \"aac\")) | limit(1;.[]) | .url")
    while IFS= read -r line; do
        echo "${line}" >> "${radio_conf}"
    done <<< "${somafm_channels}"

    # append Radio Free Fedi
    echo "http://relay.radiofreefedi.net/listen/comfy/comfy.mp3" >> ${radio_conf}
fi
echo "Radio stream URLs set to: $(cat /etc/radio.conf)"


# setup script to randomly select radio stream and start playback
curl --silent -o /usr/local/bin/radio --location https://raw.githubusercontent.com/toozej/auto-radio-player/main/radio
chmod 0775 /usr/local/bin/radio


# setup SystemD service
echo "setting up auto radio SystemD service"
tee > /etc/systemd/system/radio.service << EOF
[Unit]
Description=Auto Radio Player service

[Service]
ExecStartPre=/usr/bin/sleep 15
ExecStart=/usr/local/bin/radio
Restart=always
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF
chmod 0664 /etc/systemd/system/radio.service

# setup SystemD service timer
tee > /etc/systemd/system/radio.timer << EOF
[Unit]
Description=Timer for radio service

[Timer]
OnCalendar=daily
Persistent=true

[Install]
WantedBy=timers.target
EOF
chmod 0664 /etc/systemd/system/radio.timer
systemctl daemon-reload
systemctl enable radio.service
systemctl start radio.service


# set volume level
echo "setting volume level"
amixer -M sset PCM 90%


# Configure automatic security updates
echo "setting unattended security updates"
tee > /etc/apt/apt.conf.d/50unattended-upgrades <<EOF
Unattended-Upgrade::Origins-Patterns {
    "\${distro_id}:\${distro_codename}";
    "\${distro_id}:\${distro_codename}-updates";
    "\${distro_id}:\${distro_codename}-security";
};
Unattended-Upgrade::Package-Blacklist {
};
Unattended-Upgrade::MinimalSteps "false";
Unattended-Upgrade::Remove-Unused-Dependencies "true";
Unattended-Upgrade::Automatic-Reboot "true";
Unattended-Upgrade::Automatic-Reboot-Time "03:00";
EOF
tee > /etc/apt/apt.conf.d/20auto-upgrades <<EOF
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

echo "all done!"
