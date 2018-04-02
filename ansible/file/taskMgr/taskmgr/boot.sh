#########################################################################
# File Name: boot.sh
# Author: eric sun
# mail: ericsun@eptco.com
# Created Time: Wed 29 Jun 2016 08:26:58 PM CST
#########################################################################
#!/bin/bash

rootpath=`dirname $0`

usage() {
    echo " ** usage: sh boot.sh start/stop"
    exit -1
}

start() {
    echo "start..."
    cd ${rootpath}/sbin
    ./taskmgr -lnotice >> ../logs/thrift.log 2>&1 &
    exit 0
}

stop() {
    echo "stop..."
    cd ${rootpath}/logs
    cat taskmgr.pid | xargs kill -s USR1
    exit 0
}

if [ ! -n "$1" ]; then
    usage
fi

if [ "$1" = "start" ]; then
    start
elif [ "$1" = "stop" ]; then
    stop
else
    usage
fi

exit:
