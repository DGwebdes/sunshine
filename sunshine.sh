#!/bin/bash

echo "I'm walking on Sunshine..."
echo ""

declare -A distro_mp=(
	[debian]="apt-get"
	[ubuntu]="apt-get"
	[fedora]="dnf"
	[rhel]="dnf"
	[arch]="pacman"
	[suse]="zypper"
)

# CONFIRM OS AND PACKAGE MANAGER BEFORE START INSTALLING
osdata=$(cat /etc/os-release | grep -e 'VERSION' -e 'ID' | tr '\n' ':')
pm=""
echo "Package manager: $pm"
IFS=":" read -r -a data <<< "${osdata}" 
for d in "${data[@]}"; do
	key="${d%%=*}"	# Everything before the first =
	value="${d#*=}"	# Everything after the first =


	if [[ -n ${distro_mp[$value]+x} ]]; then
		pm=$value
		echo "The package manager is: ${distro_mp[$value]}"
	fi
done

echo "Let's get ready to rumbleee!"

sudo apt update
