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
get_lua=$(curl -L -R -O https://www.lua.org/ftp/lua-5.5.1.tar.gz)
tar_lua=$(tar zxf lua-5.5.1.tar.gz)
cd_lua=$(cd lua-5.5.1)
make_lua=$(make all test)
out_lua=$(cd ..)
cleanup_lua=$(rm -rf lua-5.*)
lua_commands=($get_lua $tar_lua $cd_lua $make_lua $out_lua $cleanup_lua)

## LuaRocks
get_luarocks=$(wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz)
tar_lr=$(tar zxpf luarocks-3.13.0.tar.gz)
cd_lr=$(cd luarocks-3.13.0)
make_lr=$(./configure && make && sudo make install)
install_lr=$(sudo luarocks install luasocket)
out_lr=$(cd ..)
cleanup_lr=$(rm -rf luarocks*)
lr_commands=($get_luarocks $tar_lr $cd_lr $make_lr $install_lr $out_lr $cleanup_lr)


# --- CONFIRM OS AND PACKAGE MANAGER BEFORE START INSTALLING ---
osdata=$(cat /etc/os-release | grep -e 'VERSION' -e 'ID' | tr '\n' ':')
pm=""
IFS=":" read -r -a data <<< "${osdata}" 
for d in "${data[@]}"; do
	key="${d%%=*}"	# Everything before the first =
	value="${d#*=}"	# Everything after the first =


	if [[ -n ${distro_pm[$value]+x} ]]; then
		pm=${distro_pm[$value]}
		echo "The package manager is: $pm"
	fi
done


# --- INSTALLATION FUNCTIONS ---
apt_install(){
	echo "apt / apt-get installs"
	#sudo $pm update

	#for i in ${essentials[@]}; do
	#	sudo $pm install $i
	#done

	echo "Installing Lua"
	for j in ${lua_commands[@]}; do
		if [[ $? > 2 ]]; then
			echo "Something went wrong"
		fi
		if [[ $? > 1 ]]; then
			echo "Unsure what happened but might not be an error"
		fi
		echo $j
	done
	echo
	for l in ${lr_commands[@]}; do
		if [[ $? > 2 ]]; then
			echo "Error occured"
		fi
		if [[ $? > 1 ]]; then
			echo "Something is up"
		fi
		echo $k
	done
	echo
}
dnf_install(){
	echo "dnf installs"
	sudo $pm upgrade

	for i in ${essentials[@]}; do
		sudo $pm install $i
	done

	echo "Installing Lua"
	for j in ${lua_commands[@]}; do
		if [[ $? > 2 ]]; then
			echo "Something went wrong"
		fi
		if [[ $? > 1 ]]; then
			echo "Unsure what happened but might not be an error"
		fi
		echo $j
	done
	echo
}
echo "Updating the system..."

case $pm in
	"apt-get")
		apt_install
		;;
	"dnf")
		dnf_install
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

