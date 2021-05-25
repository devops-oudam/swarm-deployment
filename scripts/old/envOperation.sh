#!/usr/bin/env bash

#ENV
DevEnv="13.67.54.54"
SITEnv="104.215.198.69""40.113.75.100"
UATEnv="65.52.168.67""51.144.4.184"
PRODEnv="PROD URL"


executeOperation () {
    echo "Executing operation $Action on service $Service"
    scp $WORKSPACE/scripts/executeOperation.sh $1:~/scripts
    echo "scripts/executeOperation.sh \"$Action\" $Service $Password" | ssh -tT $1
}

if [ "$Environment" == "Dev" ]; then
    echo "Starting operation for Development env..."
    executeOperation $DevEnv
elif [ "$Environment" == "SIT" ]; then
    echo "Starting operation for System Integration Testing env..."
    executeOperation $SITEnv
elif [ "$Environment" == "UAT" ]; then
    echo "Starting operation for User Acceptance Testing env..."
    executeOperation $UATEnv
elif [ "$Environment" == "PROD" ]; then
    echo "Starting operation for Production env..."
    executeOperation $PRODEnv

fi       
