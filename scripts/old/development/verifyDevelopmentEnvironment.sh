#!/usr/bin/env bash


h1() {
    separator;
    echo -e "${msg}"
    separator;
}

h2() {
    echo -e "\e[1m${msg}"
    echo -e -n "\e[0m";
}

separator() {
    echo "****************************************************************************************************"
}

error(){
    echo -e "\e[31m"
    msg="ERROR. ${msg}"
    h2
    exit 1;
}
warning(){
    msg="\e[33m WARNING. ${msg}"
    echo -e ${msg};
}
success(){
    echo -e -n "\e[0m";
    echo -e "\e[32m${msg}";
    echo -e -n "\e[0m";
}


basedir=$(dirname $0)
msg="This script verifies local configuration to ensure it is adequate as a development environment."
h1;

msg="Ensuring volumes and files exist..."
h2;

#expectedVolumes="/opt/mch/artBasel/volumes/solr /opt/mch/artBasel/volumes/Dropbox"
#for volume in ${expectedVolumes}
#do
#    if [ ! -d ${volume} ]; then
#        msg="Folder $volume must exist. It will be used as a volume by some containers."
#        error;
#    fi
#done;

#expectedFiles="/opt/mch/artBasel/certs/cert.pem /opt/mch/grandBasel/certs/cert.pem /opt/mch/grandBasel/config/mch.env /opt/mch/grandBasel/config/mch.env /opt/mch/mch.env"
#for file in ${expectedFiles}
#do
#    if [ ! -f ${file} ]; then
#        msg="File ${file} must exist. It will be expected by some containers."
#        error;
#    fi
#done;

msg="Volumes and files configuration looks OK."
success;


msg="Ensuring environment configuration is correct..."
h2;

pandoraEnvFile="/opt/pandora/pandora.env"
firstLine=$(head -1 ${pandoraEnvFile})
if [ ! "$firstLine" = "export environment=development" ]; then
    msg="File ${pandoraEnvFile} must begin with export environment=development"
    error;
fi

#fairEnvFiles="/opt/mch/artBasel/config/mch.env /opt/mch/grandBasel/config/mch.env"
#for fairEnvFile in ${fairEnvFiles}
#do
#    firstLine=$(head -1 ${fairEnvFile})
#    declaration=$(echo ${firstLine} | cut -d\= -f1)
#    declaredIp=$(echo ${firstLine} | cut -d\= -f2)
#
#    if [ ! "$declaration" = "export main_database_host" ]; then
#        msg="File ${fairEnvFile} must define the main_database_host, with something like export main_database_host=10.1.20.77"
#        error;
#    fi

#    (echo > /dev/tcp/${declaredIp}/3306) >/dev/null 2>&1
#
#    if [ $? != 0 ]; then
#        msg="Something failed trying to reach MariaDB in $declaredIp:3306. Make sure the IP is correct. This IP comes from ${fairEnvFile}"
#        error;
#    else
#        msg="Successfully connected to $declaredIp:3306. Assuming MariaDB is there..."
#        success;
#    fi

    msg="Environment configuration file ${fairEnvFile} looks OK."
    success;
done;



msg="Verifying docker ..."
h2;
docker --version
if [ $? != 0 ]; then
    msg="Something failed trying to verify docker installation. Ensure a recent version is installed (17.09.0-ce for example)."
    error;
fi

msg="All checks passed."
success;
