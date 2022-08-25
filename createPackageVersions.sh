#! /bin/bash

sortedPackagesToUpdate=$(node createPackageVersions.js)
if [[ -n $sortedPackagesToUpdate ]]
then
    packageArray=()
    packageArray+=($sortedPackagesToUpdate)
    for package in "${packageArray[@]}"
    do
        $(sfdx force:package:version:create -p $package -x -w $WAIT_TIME)
        echo "Created new version for package" $package 
    done
fi