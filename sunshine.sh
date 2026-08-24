#!/bin/bash

set -e
set -o pipefail

declare -A distro_pm=(
	[debian]="apt-get"
	[ubuntu]="apt-get"
	[fedora]="dnf"
	[rhel]="dnf"
	[arch]="pacman"
	[opensuse]="zypper"
)
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RESET='\033[0m'

## --- HELPER FUNCTIONS ---
suc_handler() {
	printf "${GREEN} %s${RESET}\n" "$1"
}

info_handler() {
	printf "${YELLOW} %s${RESET}\n" "$1"
}

error_handler(){
	printf "${RED}Error: %s${RESET}\n" "$1" >&2
	exit "${2:-1}"
}

# PRIMARY TOOLS TO INSTALL

## LUA commands and install
install_lua(){
	curl -L -R -O https://www.lua.org/ftp/lua-5.5.1.tar.gz >> install.log 2>&1 || error_handler "Curl failed to Download Lua" 2
	tar zxf lua-5.5.1.tar.gz >> install.log 2>&1 || error_handler "Tar failed to extract" 2
	cd lua-5.5.1 >> install.log 2>&1 || error_handler "Failed to cd into lua directory" 2
	make all test >> install.log 2>&1 || error_handler "Failed to build Lua" 2
	sudo make install >> install.log 2>&1 || error_handler "Failed to Install Lua" 2
	suc_handler "Cleaning up"
	cd .. 
	rm -rf lua-*
}
## LuaRocks
install_lr(){
	wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz >> install.log 2>&1 || error_handler "Wget failed to download luarocks" 2
	tar zxpf luarocks-3.13.0.tar.gz >> install.log 2>&1 || error_handler "Tar failed to extract" 2
	cd luarocks-3.13.0 >> install.log 2>&1 || error_handler "Failed to cd into LuaRocks" 2
	./configure --with-lua-include=/usr/local/include >> install.log 2>&1 && make >> install.log 2>&1 && sudo make install >> install.log 2>&1 || error_handler "Failed to build LuaRocks" 2
	sudo luarocks install luasocket  >> install.log 2>&1 || error_handler "Failed to install LuaRocks" 2
	suc_handler "Cleaning up"
	cd .. 
	rm -rf luarocks*
}
## Neovim
install_nvim(){
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz >> install.log 2>&1 || error_handler "Curl error to fetch neovim tarball" 2
	sudo rm -rf /opt/nvim-linux-x86_64 >> install.log 2>&1 || error_handler "Could not delete directory" 2
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz >> install.log 2>&1 || error_handler "Tar extraction failed" 2
	suc_handler "Cleaning up"
	rm -rf nvim-*
}
## nvim Kickstart
install_kick(){
	sudo "$1" "${@:2}" ripgrep fd-find xclip tree-sitter-cli >> install.log 2>&1 || error_handler "Failed to install kickstart essentials" 2
	git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
}

# Set ZSH as the default shell
zsh_default(){
	if ! command -v zsh >/dev/null 2>&1; then
		info_handler "Could not find zsh. Installing..."
		sudo "$1" "${@:2}" zsh >> install.log 2>&1 || error_handler "Could not install zsh" 2
		chsh -s $(command -v zsh)
	else
		info_handler "Seems like you already have it!"
		chsh -s $(command -v zsh)
	fi

	## Install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

	# Export neovim to PATH after oh-my-zsh is installed and zshrc file is set
	echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> $HOME/.zshrc || error_handler "failed to export to path" 2
	zsh
}


# --- CONFIRM OS AND PACKAGE MANAGER BEFORE START INSTALLING ---
os_pm(){

	osdata=$(cat /etc/os-release | grep -e 'VERSION' -e 'ID' | tr '\n' ':')
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

	case $pm in
		"apt-get")
			comm_update="update"
			comm_install=(install -y)
			essentials=(unzip build-essential libreadline-dev curl wget)
			;;
		"dnf")
			comm_update="upgrade"
			comm_install=(install -y)
			essentials=(unzip gcc gcc-c++ make glibc-devel readline-devel curl wget)
			;;
		"pacman")
			info_handler "running Arch I see"
			;;
		"zypper")
			info_handler "OpenSUSE is nice"
			;;
		*)
			info_handler "Keep your secrets then"
			exit 1;
			;;
	esac
	
	suc_handler "Installer and Update commands are: ${comm_install[@]} $comm_update"

	sudo "$pm" "$comm_update" >> updater.log 2>&1

	for i in "${essentials[@]}"; do
		sudo "$pm" "${comm_install[@]}" "$i" >> updater.log 2>&1 || error_handler "Failed to install essential package" 2
	done

	info_handler "Installing Lua"
	install_lua

	info_handler "Installing LuaRocks"
	install_lr

	info_handler "Installing Neovim"
	install_nvim

	info_handler "Kickstarting...(see what I did)"
	install_kick "$pm" "${comm_install[@]}"
	
	info_handler "Making zsh the default shell and installing oh-my-zsh"
	zsh_default "$pm" "${comm_install[@]}"

}

suc_handler "Updating the system..."

main(){
	os_pm
	installer
}

main

