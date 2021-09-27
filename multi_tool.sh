#!/bin/bash
# Default variables
avalanche_version="1.5.2"
# Options
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/colors.sh) --
option_value(){ echo "$1" | sed -e 's%^--[^=]*=%%g; s%^-[^=]*=%%g'; }
while test $# -gt 0; do
	case "$1" in
	-h|--help)
		. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
		echo
		echo -e "${C_LGn}Functionality${RES}: the script install Avalanche node"
		echo
		echo -e "${C_LGn}Usage${RES}: script ${C_LGn}[OPTIONS]${RES}"
		echo
		echo -e "${C_LGn}Options${RES}:"
		echo -e "  -h, --help             show the help page"
		echo -e "  -v, --version VERSION  Avalanche node VERSION to install (default is ${C_LGn}${avalanche_version}${RES})"
		echo
		echo -e "You can use either \"=\" or \" \" as an option and value ${C_LGn}delimiter${RES}"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/SecorD0/Avalanche/blob/main/installer.sh - script URL"
		echo -e "https://t.me/letskynode — node Community"
		echo
		return 0
		;;
	-v*|--version*)
		if ! grep -q "=" <<< "$1"; then shift; fi
		avalanche_version=`option_value "$1"`
		shift
		;;
	*|--)
		break
		;;
	esac
done
# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
# Actions
sudo apt update
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
sudo apt upgrade -y
sudo apt install jq pkg-config build-essential libssl-dev -y
echo -e "${C_LGn}Node installation...${RES}"
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
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/insert_variable.sh) -n "avalanch_log" -v "sudo journalctl -f -n 100 -u avalanchd" -a
echo -e "${C_LGn}Done!${RES}"
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
echo -e "\nThe node was ${C_LGn}started${RES}.\n\n"
echo -e "\tv ${C_LGn}Useful commands${RES} v\n"
echo -e "To view the node status: ${C_LGn}systemctl status avalanchd${RES}"
echo -e "To view the node log: ${C_LGn}avalanch_log${RES}"
echo -e "To restart the node: ${C_LGn}systemctl restart avalanchd${RES}"
