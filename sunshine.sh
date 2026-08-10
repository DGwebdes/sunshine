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

## --- HELPER FUNCTIONS ---
error_handler(){
	echo "Error: $1" >&2
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
	echo "Cleaning up"
	cd .. 
	rm -rf lua-*
}
## LuaRocks
install_lr(){
	wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz >> install.log 2>&1 || error_handler "Wget failed to download luarocks" 2
	tar zxpf luarocks-3.13.0.tar.gz >> install.log 2>&1 || error_handler "Tar failed to extract" 2
	cd luarocks-3.13.0 >> install.log 2>&1 || error_handler "Failed to cd into LuaRocks" 2
	./configure --with-lua-include=/usr/local/include && make && sudo make install >> install.log 2>&1 || error_handler "Failed to build LuaRocks" 2
	sudo luarocks install luasocket  >> install.log 2>&1 || error_handler "Failed to install LuaRocks" 2
	echo "Cleaning up"
	cd .. 
	rm -rf luarocks*
}
## Neovim
install_nvim(){
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz >> install.log 2>&1 || error_handler "Curl error to fetch neovim tarball" 2
	sudo rm -rf /opt/nvim-linux-x86_64 >> install.log 2>&1 || error_handler "Could not delete directory" 2
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz >> install.log 2>&1 || error_handler "Tar extraction failed" 2
	rm -rf nvim-*
	echo "Neovim Installed"
}
## nvim Kickstart
install_kick(){
	sudo $1 $2 $3 ripgrep fd-find xclip tree-sitter-cli >> install.log 2>&1 || error_handler "Failed to install kickstart essentials" 2
	git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
}

# Set ZSH as the default shell
zsh_default(){
	if ! command -v zsh >/dev/null 2>&1; then
		echo "Could not find zsh. Installing..."
		sudo $1 $2 $3 zsh >> install.log 2>&1 || error_handler "Could not install zsh" 2
		chsh -s $(command -v zsh)
	else
		echo "Seems like you already have it!"
		chsh -s $(command -v zsh)
	fi

	## Install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
	echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> $HOME/.zshrc >> install.log 2>&1 || error_handler "failed to export to path" 2
	zsh
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

	case $pm in
		"apt-get")
			comm_update="update"
			comm_install=(install -y)
			essentials=(unzip build-essential libreadline-dev curl wget)
			;;
		"dnf")
			comm_update="check-update"
			comm_install=(install -y)
			essentials=(unzip gcc gcc-c++ make glibc-devel readline-devel curl wget)
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
	
	echo "Installer and Update commands are: $comm_install $comm_update"

	sudo "$pm" "$comm_update"

	for i in "${essentials[@]}"; do
		sudo "$pm" "${comm_install[@]}" "$i"
	done

	echo "Installing Lua"
	install_lua
	install_lr
	echo

	echo "Installing Neovim"
	install_nvim
	echo

	echo "Kickstarting...(see what I did)"
	install_kick "$pm" "${comm_install[@]}"
	echo
	
	echo "Making zsh the default shell and installing oh-my-zsh"
	zsh_default "$pm" "${comm_install[@]}"
	echo

}

echo "Updating the system..."

main(){
	os_pm
	installer
}

main

