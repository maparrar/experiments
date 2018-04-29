#!/bin/sh
# maparrar@gmail.com
# https://github.com/maparrar/devel
# 2018-02-20


# Ask for sudo validation
[ "$(whoami)" != "root" ] && exec sudo -- "$0" "$@"
#echo "$(whoami)"
#[ "$UID" -eq "0" ] || exec sudo "./$0" "$@"

ls


# Ask for data input:
#read -p "Username: " username
#echo  $username



#cd devel
cp devel /usr/local/bin/devel 



#=========================================




