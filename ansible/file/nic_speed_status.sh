#!/bin/sh

nic=$1

MaxSpeed=$(sudo ethtool $nic | grep "base" |awk '{print $NF}' | sed  's/.*\(10.*\)base.*/\1/' | sort -nr | head -1)
CurrentSpeed=$(sudo ethtool $nic |grep Speed | sed 's/.*Speed: \(.*\)Mb.*/\1/')

if [ $CurrentSpeed -lt $MaxSpeed ];then
    echo $CurrentSpeed
else
    echo 0
fi


