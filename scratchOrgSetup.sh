#! /bin/bash
while getopts u:p: flag
do
    case "${flag}" in
        u) username=${OPTARG};;
        p) package=${OPTARG};;
    esac
done

username=${username:-$(sf config get target-org --json | jq -r '.result[0].value')}
package=${package:?"Please input the package to install the dependencies of."}

jsonDependencies=($(sf data query -o RecommendedBadges -t -q "SELECT Dependencies FROM SubscriberPackageVersion WHERE Id='$package'" --json | jq -c '[.result.records[0].Dependencies.ids | .[].subscriberPackageVersionId]'))
dependencies=()
dependencies+=( $(echo ${jsonDependencies:1:(${#jsonDependencies}-2)} | tr "," " " | tr -d '"') )

if ((${#dependencies[@]} > 0))
then
    for id in ${dependencies[@]}
    do
        echo "Installing dependent package: "$id
        sf package install -p $id -o $username -r -w 20
        echo ""
    done
fi
