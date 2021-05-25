#!/usr/bin/env bash

if [ $# -ne 2 ]; then
    echo "You must pass the artifact name and version as parameter."
    echo "For example: $0 pandora-gateway 1.2.3"
    exit 1
fi

validateArtifactName() {
    if [[ $1 =~ ^[a-zA-Z0-9_-]{4,40}$ ]]; then
        echo "Artifact name \"$1\" looks correct";
    else
        echo "Artifact name \"$1\" doesn't look very correct. Aborting to avoid disaster."
        exit 0;
    fi
}

validateVersion() {
    if [[ $1 =~ ^([0-9]{1,5}\.){1,5}[0-9]{1,5}$ ]]; then
        echo "Version \"$1\" looks correct";
    else
        echo "Version \"$1\" doesn't look very correct. Aborting to avoid disaster."
        exit 0;
    fi
}

basedir=$(dirname $0)
rootDir=$basedir/../..

artifactName=$1
version=$2

echo "Upgrading in docker-compose.yml artifact $artifactName to version $version"

validateArtifactName ${artifactName}
validateVersion ${version}

(cd ${rootDir} && git checkout develop)
(cd ${rootDir} && git pull --rebase)
sed -i -E "s/(${artifactName}):(([0-9]{1,5}\.){1,5}[0-9]{1,5})/\1:${version}/" ${rootDir}/docker-compose.yml
(cd ${rootDir} && git add docker-compose.yml)
(cd ${rootDir} && git commit -m "CD - Changed $artifactName to $version.")
(cd ${rootDir} && git push --set-upstream origin develop)

