#!/usr/bin/env bash
#zabbix discovery ethtool speed

echo -e "{"
echo -e "\t\"data\":["

ARRY=(`ifconfig |grep RUNNING |grep MULTICAST|awk '/^[a-z]/ {print $1}'|egrep -o '[a-z0-9-]+'`)
NUM=$(echo $((${#ARRY[@]}-1)))
for i in `seq 0 $NUM`
    do
        NUM=$(echo $((${#ARRY[@]}-1)))
        if [ $i != $NUM ]; then
            echo -e "\t\t{"
            echo -e "\t\t\t\"{#PETH}\":\"${ARRY[$i]}\"},"
        else
            echo -e "\t\t{"
            echo -e "\t\t\t\"{#PETH}\":\"${ARRY[$i]}\"}"
        fi
    done

echo -e "\t]"
echo -e "}"
