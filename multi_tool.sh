#!/bin/bash
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
		echo -e "  -h, --help  show the help page"
		echo
		echo -e "${C_LGn}Useful URLs${RES}:"
		echo -e "https://github.com/SecorD0/Avalanche/blob/main/multi_tool.sh - script URL"
		echo -e "https://t.me/letskynode — node Community"
		echo
		return 0
		;;
	*|--)
		break
		;;
	esac
done
# Functions
printf_n(){ printf "$1\n" "${@:2}"; }
# Actions
sudo apt install wget -y
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
sudo apt update
sudo apt upgrade -y
sudo apt install jq pkg-config build-essential libssl-dev -y
echo -e "${C_LGn}Node installation...${RES}"
cd
avalanche_version=`wget -qO- https://api.github.com/repos/ava-labs/avalanchego/releases/latest | jq -r ".tag_name"`
wget "https://github.com/ava-labs/avalanchego/releases/download/${avalanche_version}/avalanchego-linux-amd64-${avalanche_version}.tar.gz"
tar -xvf "avalanchego-linux-amd64-${avalanche_version}.tar.gz"
rm "avalanchego-linux-amd64-${avalanche_version}.tar.gz"
mv $HOME`find / -name "avalanchego*" -type d -printf '/%f'` $HOME/avalanche
chmod +x $HOME/avalanche/avalanchego
sudo tee <<EOF >/dev/null /etc/systemd/system/avalanched.service
[Unit]
Description=Avalanche Node
After=network-online.target

[Service]
User=$USER
ExecStart=$HOME/avalanche/avalanchego
Restart=always
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
sudo systemctl enable avalanched
sudo systemctl daemon-reload
sudo systemctl restart avalanched
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/miscellaneous/insert_variable.sh) -n "avalanche_log" -v "sudo journalctl -f -n 100 -u avalanched" -a
echo -e "${C_LGn}Done!${RES}"
. <(wget -qO- https://raw.githubusercontent.com/SecorD0/utils/main/logo.sh)
echo -e "\nThe node was ${C_LGn}started${RES}.\n\n"
echo -e "\tv ${C_LGn}Useful commands${RES} v\n"
echo -e "To view the node status: ${C_LGn}systemctl status avalanched${RES}"
echo -e "To view the node log: ${C_LGn}avalanche_log${RES}"
echo -e "To restart the node: ${C_LGn}systemctl restart avalanched${RES}"
