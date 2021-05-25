#!/usr/bin/env bash

basedir=$(dirname $(readlink -f $0))

docker stack deploy CLIK --compose-file ${basedir}/../../docker-compose.yml
