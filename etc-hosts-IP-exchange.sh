#!/bin/bash
#
# UPDATE THE IP OF A MACHINE IN ETC/HOSTS
#
# eg : ./etc-hosts-IP-exchange.sh MACHINE-NAME 10.10.10.10
#
# S'assurer de lancer le script avec sudo.
# Be sure to run it within root privileges.
#
# Version de production : v4 - 23/11/2016
# Jimmy B.
# @133_cesium

sed -i "/"$1"/c\\"$2'\t\t'$1 /etc/hosts
printf "Changement apporté à /etc/hosts\n$2     $1\n"
