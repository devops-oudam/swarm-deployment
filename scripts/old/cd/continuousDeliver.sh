#!/usr/bin/env bash

basedir=$(dirname $0)
rootDir=$basedir/../..

currentMd5=$(md5sum $rootDir/docker-compose.yml | cut -d\  -f1)
storedMd5=$(cat $basedir/test.md5)
if [ "${currentMd5}" != "${storedMd5}" ]; then
    echo "Hash of previously deployed yml: ${storedMd5}, current file is ${currentMd5}. Marking repository as dirty, so stackdeploy will be launched."
    touch $basedir/dirty
else
    echo "No changes detected in the docker-compose.yml file. No need to build anything."
    rm -f $basedir/dirty
fi
