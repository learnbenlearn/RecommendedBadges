#! /bin/bash
while getopts u:p: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) package=${OPTARG};;
    esac
done

username=${username:-$(sfdx force:config:get defaultusername --json | jq -r '.result[0].value')}
package=${package:?"Please input the package to install."}

jsonDependencies=($(sfdx force:data:soql:query -u RecommendedBadges -t -q "SELECT Dependencies FROM SubscriberPackageVersion WHERE Id='$package'" --json | jq -c '[.result.records[0].Dependencies.ids | .[].subscriberPackageVersionId]'))
dependencies=()
dependencies+=( $(echo ${jsonDependencies:1:(${#jsonDependencies}-2)} | tr "," " " | tr -d '"') )

for id in ${dependencies[@]}
do
    echo "Installing dependent package: "$id
    sfdx force:package:install -p $id -u $username -r -w 20
    echo ""
done

echo "Installing package: " $package
sfdx force:package:install -p $id -u $username -r -w 20