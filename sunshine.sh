#!/bin/bash

echo "I'm walking on Sunshine..."
echo ""

declare -A distro_pm=(
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
IFS=":" read -r -a data <<< "${osdata}" 
for d in "${data[@]}"; do
	key="${d%%=*}"	# Everything before the first =
	value="${d#*=}"	# Everything after the first =


	if [[ -n ${distro_pm[$value]+x} ]]; then
		pm=${distro_pm[$value]}
		echo "The package manager is: $pm"
	fi
done

echo "Let's get ready to rumbleee!"
echo "Updating the system..."

case $pm in
	"apt-get")
		echo "Debian underhood"
		;;
	"dnf")
		echo "Fedora, Rhel or Centos"
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
