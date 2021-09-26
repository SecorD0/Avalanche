# $1 - Avalanche node version
#!/bin/bash
if [ -n "$1" ]; then
	avalanche_version=$1
else
	avalanche_version="1.5.2"
fi
sudo apt update
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
sudo apt upgrade -y
sudo apt install jq pkg-config build-essential libssl-dev -y
cd
wget "https://github.com/ava-labs/avalanchego/releases/download/v${avalanche_version}/avalanchego-linux-amd64-v${avalanche_version}.tar.gz"
tar -xvf "avalanchego-linux-amd64-v${avalanche_version}.tar.gz"
rm "avalanchego-linux-amd64-v${avalanche_version}.tar.gz"
chmod +x $HOME$(find / -name "avalanchego*" -type d -printf '/%f')/avalanchego
sudo tee <<EOF >/dev/null /etc/systemd/system/avalanchd.service
[Unit]
Description=Avalanch Node
After=network-online.target
[Service]
User=$USER
ExecStart=$HOME$(find / -name "avalanchego*" -type d -printf '/%f')/avalanchego
Restart=always
RestartSec=3
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable avalanchd
sudo systemctl daemon-reload
sudo systemctl restart avalanchd
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/insert_variable.sh) "avalanch_log" "sudo journalctl -f -n 100 -u avalanchd" true
echo -e '\e[40m\e[92mDone!\e[0m'
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
echo -e '\nThe node was \e[40m\e[92mstarted\e[0m.\n\n'
echo -e '\tv \e[40m\e[92mUseful commands\e[0m v\n'
echo -e 'To view the node status: \e[40m\e[92msystemctl status avalanchd\e[0m'
echo -e 'To view the node log: \e[40m\e[92mavalanch_log\e[0m'
echo -e 'To restart the node: \e[40m\e[92msystemctl restart avalanchd\e[0m\n'
