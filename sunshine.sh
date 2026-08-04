#!/bin/bash

echo "I'm walking on Sunshine..."
echo ""

# I'M REALLY SORRY YOU HAVE TO SEE THIS! BUT I DON'T WANT TO USE MORE THAN ONE FILE. SO HERE IT GOES: variables & arrays
declare -A distro_pm=(
	[debian]="apt-get"
	[ubuntu]="apt-get"
	[fedora]="dnf"
	[rhel]="dnf"
	[arch]="pacman"
	[suse]="zypper"
)
essentials=(build-essential libreadline-dev unzip)

## LUA commands and install
install_lua(){
	$(curl -L -R -O https://www.lua.org/ftp/lua-5.5.1.tar.gz) \
	$(tar zxf lua-5.5.1.tar.gz) \
	$(cd lua-5.5.1) \
	$(make all test) \
	$(cd ..) \
	$(rm -rf lua-*)
}
## LuaRocks
install_lr(){
	$(wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz) \
	$(tar zxpf luarocks-3.13.0.tar.gz) \
	$(cd luarocks-3.13.0) \
	$(./configure && make && sudo make install) \
	$(sudo luarocks install luasocket) \
	$(cd ..) \
	$(rm -rf luarocks*)
}
## Neovim
instal_nvim(){
	$(curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz) \
	$(sudo rm -rf /opt/nvim-linux-x86_64) \
	$(sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz) \
	$(export PATH="$PATH:/opt/nvim-linux-x86_64/bin" >> .bashrc)
}
## nvim Kickstart
install_kick(){
	sudo $1 install ripgreg fd-find xclip tree-sitter-cli
	if [[ $? > 1 ]]; then
		echo "something went wrong with the previous step"
	else
		echo "cool, we can kickstart now"
		echo
		git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
	fi
}

# --- CONFIRM OS AND PACKAGE MANAGER BEFORE START INSTALLING ---
os_pm(){

	osdata=$(cat /etc/os-release | grep -e 'VERSION' -e 'ID' | tr '\n' ':')
	pm=""
	IFS=":" read -r -a data <<< "${osdata}" 
	for d in "${data[@]}"; do
		key="${d%%=*}"	# Everything before the first =
		value="${d#*=}"	# Everything after the first =


		if [[ -n ${distro_pm[$value]+x} ]]; then
			pm=${distro_pm[$value]}
		fi
	done
}

# --- INSTALLATION FUNCTIONS ---
installer(){
	echo "pm is: $pm"
	inst_comm=''


	case $pm in
		"apt-get")
			inst_comm="update"
			;;
		"dnf")
			inst_comm="upgrade"
			;;
		"pacman")
			echo "running Arch I see"
			;;
		"zypper")
			echo "OpenSUSE is nice"
			;;
		*)
			echo "Keep your secrets then"
			;;
	esac
	
	echo $inst_comm

	#sudo $pm $inst_comm

	#for i in ${essentials[@]}; do
	#	sudo $pm install $i
	#done

	echo "Installing Lua"
	install_lua
	install_lr
	echo

	echo "Installing Neovim"
	install_nvim
	echo
}

echo "Updating the system..."

main(){
	os_pm
	installer
}

main

