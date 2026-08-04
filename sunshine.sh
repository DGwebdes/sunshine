#!/bin/bash

echo "I'm walking on Sunshine..."
echo ""
distros=(debian fedora centos arch)
# CONFIRM OS AND PACKAGE MANAGER BEFORE START INSTALLING
osdata=$(cat /etc/os-release | grep -e 'VERSION' -e 'ID' | tr '\n' ':')

IFS=":" read -r -a data <<< "${osdata}" 
for d in "${data[@]}"; do
	echo "data: $d"
	if [ "$d" = "ID=debian" ]; then
		echo "Debian found"
	fi
done

for i in "${distros[@]}"; do
	echo $i
done
