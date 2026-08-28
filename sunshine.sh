#!/bin/bash

set -e
set -o pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
PURPLE='\033[0;35m'
RESET='\033[0m'

package_manager=("dpkg" "apt" "apt-get" "rpm" "yum" "dnf" "zypper" "pacman")


## --- HELPER FUNCTIONS ---
job_done() {
	printf "${GREEN} %s${RESET}\n" "$1"
}

step_counter() {
	printf "${PURPLE} %s${RESET}\n" "$1"
}

info_handler() {
	printf "${YELLOW} %s${RESET}\n" "$1"
}

error_handler(){
	printf "${RED}Error: %s${RESET}\n" "$1" >&2
	exit "${2:-1}"
}

# TOOLS TO INSTALL

## LUA commands and install
install_lua(){
	curl -L -R -O https://www.lua.org/ftp/lua-5.5.1.tar.gz >> lua_install.log 2>&1 || error_handler "Curl failed to Download Lua" 2
	tar zxf lua-5.5.1.tar.gz >> lua_install.log 2>&1 || error_handler "Tar failed to extract" 2
	cd lua-5.5.1 >> lua_install.log 2>&1 || error_handler "Failed to cd into lua directory" 2
	make all test >> lua_install.log 2>&1 || error_handler "Failed to build Lua" 2
	sudo make install >> lua_install.log 2>&1 || error_handler "Failed to Install Lua" 2
	job_done "Cleaning up"
	cd .. || error_handler "Failed to change directory back.." 2
	rm -rf lua-* || error_handler "Failed to clean up Lua install" 2
}
## LuaRocks
install_lr(){
	wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz >> lr_install.log 2>&1 || error_handler "Wget failed to download luarocks" 2
	tar zxpf luarocks-3.13.0.tar.gz >> lr_install.log 2>&1 || error_handler "Tar failed to extract" 2
	cd luarocks-3.13.0 >> lr_install.log 2>&1 || error_handler "Failed to cd into LuaRocks" 2
	./configure --with-lua-include=/usr/local/include >> lr_install.log 2>&1 && make >> lr_install.log 2>&1 && sudo make install >> lr_install.log 2>&1 || error_handler "Failed to build LuaRocks" 2
	sudo luarocks install luasocket  >> lr_install.log 2>&1 || error_handler "Failed to install LuaRocks" 2
	job_done "Cleaning up"
	cd .. || "Failed to changed directory back.." 2
	rm -rf luarocks* || "Failed to clean up LuaRocks install" 2
}
## Neovim
install_nvim(){
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz >> install.log 2>&1 || error_handler "Curl error to fetch neovim tarball" 2
	sudo rm -rf /opt/nvim-linux-x86_64 >> nvim_install.log 2>&1 || error_handler "Could not delete directory" 2
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz >> nvim_install.log 2>&1 || error_handler "Tar extraction failed" 2
	job_done "Cleaning up"
	rm -rf nvim-* || "Failed to clean up neovim install" 2
}
## nvim Kickstart
install_kick(){
	git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim || error_handler "Failed to clone neovim" 2
	job_done "Kickstart cloned and working"
}

# Set ZSH as the default shell
install_omz(){
	## Install oh-my-zsh
	RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" <<< "y" >> omz.log 2>&1 || error_handler "Failed to install oh-my-zsh" 2

	# Export neovim to PATH after oh-my-zsh is installed and zshrc file is set
	echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> $HOME/.zshrc || error_handler "failed to export to path" 2

	# Collecting logs into one directory
	job_done "Tidying up the room..."
	mkdir -p sunshine-logs && mv ./*.log sunshine-logs

	# spawning zsh Shell
	exec zsh -l
}


# --- CONFIRM OS AND PACKAGE MANAGER BEFORE START INSTALLING ---
os_pm(){

	for manager in "${package_manager[@]}"; do
		if command -v "$manager" > /dev/null 2>&1; then
			case $manager in
				"apt-get"|"apt"|"dpkg")
					pm="apt-get"
					;;
				"dnf"|"yum"|"rpm")
					pm="dnf"
					;;
				"pacman")
					pm="pacman"
					;;
				"zypper")
					pm="zypper"
					;;
					
				*)
					echo "We do not support the PM found."
					exit 1
					;;
			esac
		fi
	done
	info_handler "Package Manager Found: $pm"

}

# --- INSTALLATION FUNCTIONS ---
installer(){

	case $pm in
		"apt-get")
			comm_update="update"
			comm_install=(install -y)
			essentials=(unzip build-essential libreadline-dev curl wget ripgrep fd-find xclip tree-sitter-cli)
			;;
		"dnf")
			comm_update="upgrade"
			comm_install=(install -y)
			essentials=(unzip gcc gcc-c++ make glibc-devel readline-devel curl wget ripgrep fd-find xclip tree-sitter-cli)
			;;
		"pacman")
			comm_update="-Syu"
			comm_install=(-S --noconfirm)
			essentials=(unzip curl wget gcc make glibc readline ripgrep fd xclip tree-sitter-cli)
			;;
		"zypper")
			comm_update="refresh"
			comm_install=(install -y)
			essentials=(unzip curl wget gcc gcc-c++ make glibc-devel readline-devel ripgrep fd xclip tree-sitter)
			;;
		*)
			info_handler "Keep your secrets then"
			exit 1;
			;;
	esac
	
	step_counter "Step 1 of 7"
	info_handler "Updating the system..."
	
	sudo "$pm" "$comm_update" >> updater.log 2>&1 || error_handler "Failed to update the system..." 2
	
	job_done "System up to date"
	
	step_counter "Step 2 of 7"
	info_handler "Installing essentials"

	for i in "${essentials[@]}"; do
		sudo "$pm" "${comm_install[@]}" "$i" >> updater.log 2>&1 || error_handler "Failed to install essential package" 2
	done

	job_done "Essentials packages installed"

	step_counter "Step 3 of 7"
	info_handler "Installing Lua..."
	install_lua

	step_counter "Step 4 of 7"
	info_handler "Installing LuaRocks..."
	install_lr

	step_counter "Step 5 of 7"
	info_handler "Installing Neovim..."
	install_nvim

	step_counter "Step 6 of 7"
	info_handler "Kickstarting...(see what I did)..."
	install_kick
	
	step_counter "Step 7 of 7"
	info_handler "Installing oh-my-zsh..."
	install_omz

}

# Actually implement the Script

main(){
	os_pm
	installer
}

main

