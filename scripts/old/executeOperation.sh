#!/usr/bin/env bash

checkPassword(){
    if [ -f /opt/mch/deploy.password ]; then
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

action="$1"
service="$2"
password="$3"
stackName="pandora"

checkPassword

echo "**************************************************"
echo " Starting execution of action $action on $service..."
echo "**************************************************"


if [ "$action" == "Restart nicely" ]; then
    docker service update --env-add randomFakeVariable_$RANDOM=$RANDOM $service --detach=false
elif [ "$action" == "Stop" ]; then
    docker service scale $service=0 --detach=false
elif [ "$action" == "Scale to 1 instance" ]; then
    docker service scale $service=1 --detach=false
elif [ "$action" == "Scale to 2 instances" ]; then
    docker service scale $service=2 --detach=false
elif [ "$action" == "Scale to 3 instances" ]; then
    docker service scale $service=3 --detach=false
fi

echo "**************************************************"
echo " Execution of action $action on $service finished."
echo "**************************************************"
