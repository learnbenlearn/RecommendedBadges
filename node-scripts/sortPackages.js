#!/bin/env node

const getPackageNameFromDependency = require('./getPackageNameFromDependency.js');

async function sortPackages(packages, PACKAGE_DIRECTORIES) {
    let packagesWithDependencies = {};

    for(let packageDirectory of PACKAGE_DIRECTORIES) {
        if(packages.has(packageDirectory.package)) {
            let dependencies = [];
            if(packageDirectory.dependencies) {
                for(let dependentPackage of packageDirectory.dependencies) {
                    let packageName = await getPackageNameFromDependency(dependentPackage)
                    if(packages.has(packageName)) {
                        dependencies.push(packageName);
                    }
                }
            }
            packagesWithDependencies[packageDirectory.package] = dependencies;
        }
    }

    let sortedPackages = [];
    let rootNodes = getStartNodes(packagesWithDependencies);

    while(rootNodes.length) {
        sortedPackages.push(...rootNodes);
        let newRootNodes = [];
        for(let package in packagesWithDependencies) {
                if(rootNodes.includes(package)) {
                    delete packagesWithDependencies[package];
                } else {
                    packagesWithDependencies[package] = packagesWithDependencies[package].filter(element => {
                    return !rootNodes.includes(element);
                });
                if(!packagesWithDependencies[package].length) {
                    newRootNodes.push(package);
                }
            }
        }
        rootNodes = newRootNodes;
    }
    return sortedPackages;
}

function getStartNodes(nodeList) {
    let startNodes = [];
    for(let node in nodeList) {
        if(nodeList[node].length == 0) {
            startNodes.push(node);
        }
    }
    return startNodes;
}

module.exports = sortPackages;