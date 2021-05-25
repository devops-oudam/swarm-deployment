#!/usr/bin/env bash

checkPassword(){
    if [ -f /opt/pandora/deploy.password ]; then
        echo "Environment is password protected. Verifying..."
        environmentPassword=$(cat /opt/pandora/deploy.password)
        if [ "${environmentPassword}" != "$password" ]; then
            echo "****************************************"
            echo "Password is invalid for this environment."
            #echo "Provided password: $password"
            #echo "Required password: $environmentPassword"
            echo "****************************************"
            exit 1;
        else
            echo "Password validation successful."
        fi
    else
        echo "Environment is not password protected."
    fi
}

validateYml(){
    if (cat ${composeFile} | grep "nexus.clik-staging.com" | grep "SNAPSHOT"); then
        echo "Cannot start stack. SNAPSHOT versions found"
        exit 1
    fi
}

revealYml(){
    echo "Deploying ${stackName} stack with contents: "
    cat ${composeFile}
}

startStack(){
    validateYml
    revealYml
    docker stack deploy ${stackName} --compose-file ${composeFile} --with-registry-auth
}

stopStack(){
    docker stack rm ${stackName}
    limit=60
    until [ -z "$(docker service ls --filter label=com.docker.stack.namespace=${stackName} -q)" ] || [ "${limit}" -lt 0 ]; do
        echo "(${limit}) Waiting for all services to die..."
        sleep 1;
        limit=$((limit-1))
    done
    limit=60
    until [ -z "$(docker network ls --filter label=com.docker.stack.namespace=${stackName} -q)" ] || [ "${limit}" -lt 0 ]; do
        echo "(${limit}) Waiting for all networks to die..."
        sleep 1;
        limit=$((limit-1))
    done
}

##################################################################
#  Execution starts here.
##################################################################

if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: $0 <deploymentType> <composeFile> [password]."
    echo "       deploymentType is either Force or Incremental"
    echo "       composeFile is the path to the docker-compose.yml file to use."
    exit 1
fi

deploymentType="$1"
composeFile="$2"
password="$3"
stackName="GMS"

checkPassword;


if [ "${deploymentType}" == "Force" ]; then
    stopStack
    startStack
elif [ "${deploymentType}" == "Incremental" ]; then
    startStack
elif [ "${deploymentType}" == "Shutdown" ]; then
    stopStack
elif [ "${deploymentType}" == "Clean" ]; then
    echo "Nothing to do, exiting."
else
    echo "Unknown deployment type ${deploymentType}"
    exit 1
fi
