#!/usr/bin/env bash

basedir=$(dirname $0)
rootDir=$basedir/../..

echo "Creating md5 of yml file"
if [ "$Environment" = "test" ]; then
    currentMd5=$(md5sum $rootDir/docker-compose.yml | cut -d\  -f1)
    (cd ${rootDir} && git checkout ${BRANCH})
    (cd ${rootDir} && git pull --rebase)
    echo ${currentMd5} > $basedir/$Environment.md5
    (cd ${rootDir} && git add ${basedir}/${Environment}.md5)
    (cd ${rootDir} && git commit -m "CD - Added hash of deployed file to ${Environment}.md5")
    (cd ${rootDir} && git push --set-upstream origin ${BRANCH})
else
    echo "Calculation of md5 skipped, since current is environment is ${Environment}"
fi
