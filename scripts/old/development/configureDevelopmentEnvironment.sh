#!/usr/bin/env bash

rootcheck () {
    if [ $(id -u) != "0" ]
    then
        echo This command must be executed as root. It requires writing to /opt
        exit 1
    fi
}

rootcheck;

if [ $# -ne 2 ]; then
    echo "USAGE: $0 user interface "
    echo "   user. User that will be used to develop and run the application later (carlos for example)."
    echo "   interface. Network interface where the database is listening (eth0 for example)."
    exit 1
fi

basedir=$(dirname $(readlink -f $0))
user=$1
interface=$2
detectedIp=$(/sbin/ifconfig ${interface} | grep "inet " | awk -F' ' '{print $2}' | awk '{print $1}')
if [ "${detectedIp}" == "" ]; then
    echo "Could not detect IP associated to interface $interface"
    exit 1;
fi

su -l ${user} -c "$basedir/../../sources/getAllSources.sh"

pandoraEnvFile=/opt/pandora/pandora.env
echo "export environment=development">${pandoraEnvFile}

su -l ${user} -c "$basedir/verifyDevelopmentEnvironment.sh"
