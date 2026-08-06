#!/bin/bash

set -e
set -o pipefail

# I'M REALLY SORRY YOU HAVE TO SEE THIS! BUT I DON'T WANT TO USE MORE THAN ONE FILE. SO HERE IT GOES: variables & arrays
declare -A distro_pm=(
	[debian]="apt-get"
	[ubuntu]="apt-get"
	[fedora]="dnf"
	[rhel]="dnf"
	[arch]="pacman"
	[opensuse]="zypper"
)
essentials=(build-essential libreadline-dev unzip)

## --- HELPER FUNCTIONS ---
error_handler(){
	echo "Error: $1" >&2
	exit "${2:-1}"
}

# PRIMARY TOOLS TO INSTALL

## LUA commands and install
install_lua(){
	curl -L -R -O https://www.lua.org/ftp/lua-5.5.1.tar.gz || error_handler "Curl failed to Download Lua" 2 
	tar zxf lua-5.5.1.tar.gz || error_handler "Tar failed to extract" 2
	cd lua-5.5.1 || error_handler "Failed to cd into lua directory" 2
	make all test || error_handler "Failed to build lua" 2
	cd .. 
	rm -rf lua-*
}
## LuaRocks
install_lr(){
	wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz || error_handler "Wget failed to download luarocks" 2
	tar zxpf luarocks-3.13.0.tar.gz || error_handler "Tar failed to extract" 2
	cd luarocks-3.13.0 || error_handler "Failed to cd into luarocks" 2
	./configure && make && sudo make install || error_handler "Failed to build" 2
	sudo luarocks install luasocket  || error_handler "Failed to install luarocks" 2
	cd .. 
	rm -rf luarocks*
}
## Neovim
install_nvim(){
	curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz || error_handler "Curl error to fetch neovim tarball" 2
	sudo rm -rf /opt/nvim-linux-x86_64 || error_handler "Could not delete directory" 2
	sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz || error_handler "Tar extraction failed" 2
	echo 'export PATH="$PATH:/opt/nvim-linux-x86_64/bin"' >> $HOME/.bashrc || error_handler "failed to export to path" 2
	echo "Neovim Installed"
}
## nvim Kickstart
install_kick(){
	sudo $1 install ripgrep fd-find xclip tree-sitter-cli || error_handler "Failed to install kickstart essentials" 2
	git clone https://github.com/nvim-lua/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim
}

# Set ZSH as the default shell
zsh_default(){
	if ! which zsh >/dev/null 2>&1; then
		echo "Could not find zsh. Installing..."
		sudo $1 install zsh || error_handler "Could not install zsh" 2
		chsh -s $(which zsh)
	else
		echo "Seems like you already have it!"
		chsh -s $(which zsh)
	fi

	## Install oh-my-zsh
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
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
	inst_comm=""


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
	
	echo "$inst_comm"

	sudo "$pm" "$inst_comm"

	for i in "${essentials[@]}"; do
		sudo "$pm" install -y "$i"
	done

	echo "Installing Lua"
	install_lua
	install_lr
	echo

	echo "Installing Neovim"
	install_nvim
	echo

	echo "Kickstarting...(see what I did)"
	install_kick "$pm"
	echo

	echo "Making zsh the default shell and installing oh-my-zsh"
	zsh_default
	echo
}

echo "Updating the system..."

main(){
	os_pm
	installer
}

main

