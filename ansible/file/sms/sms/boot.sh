#!/bin/bash

rootpath=`dirname $0`

usage() {
    echo " ** usage: sh boot.sh start/stop"
    exit -1
}

start() {
    echo "start..."
    cd ${rootpath}/sbin
    ./sms -lnotice -n/data/log/sms/sms.log >> /data/log/sms/thrift.log &
    exit 0
}

stop() {
    echo "stop..."
    cd ${rootpath}/logs
    cat sms.pid | xargs kill -s USR1
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