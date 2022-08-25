const fs = require ('fs');
const util = require('util');
const exec = util.promisify(require('child_process').exec);
//b851edc4a777261f401611c03117e5b513c6a203
async function getChangedPackageDirectories() {
    let changedFiles = [];
    let changedPackageDirectories = new Set();
    try {
        const {stdout, stderr} = await exec('git diff HEAD  --name-only');
        if(stderr) {
            console.log(stderr);
        } else {
            changedFiles = stdout.split('\n');
            for(let changedFile of changedFiles) {
                if(changedFile.indexOf('/') != -1) {
                    changedPackageDirectories.add(changedFile.substring(0, changedFile.indexOf('/')));
                }
            }
        }
    } catch(err) {
        console.error(err);
    }
    return changedPackageDirectories;
}

function getPackagesToUpdate(changedPackageDirectories, sfdxProjectJSON) {
    let packagesToUpdate = new Set();
    for(let packageDirectory of sfdxProjectJSON.packageDirectories) {
        if(changedPackageDirectories.has(packageDirectory.path)) {
            packagesToUpdate.add(packageDirectory.package);
        }
    }

    for(let packageDirectory of sfdxProjectJSON.packageDirectories) {
        if(packageDirectory.dependencies) {
            for(let dependentPackage of packageDirectory.dependencies) {
                if(packagesToUpdate.has(dependentPackage.package)) {
                    packagesToUpdate.add(packageDirectory.package);
                }
            }
        }
    }

    return packagesToUpdate;
}

function sortPackagesToUpdate(packagesToUpdate, sfdxProjectJSON) {
    let packagesToUpdateWithDependencies = {};

    for(let packageDirectory of sfdxProjectJSON.packageDirectories) {
        if(packagesToUpdate.has(packageDirectory.package)) {
            let dependencies = [];
            if(packageDirectory.dependencies) {
                for(let dependentPackage of packageDirectory.dependencies) {
                    if(packagesToUpdate.has(dependentPackage.package)) {
                        dependencies.push(dependentPackage.package);
                    }
                }
            }
            packagesToUpdateWithDependencies[packageDirectory.package] = dependencies;
        }
    }

    let sortedPackagesToUpdate = [];
    let rootNodes = getStartNodes(packagesToUpdateWithDependencies);

    while(rootNodes.length) {
        sortedPackagesToUpdate.push(...rootNodes);
        let newRootNodes = [];
        for(let package in packagesToUpdateWithDependencies) {
                if(rootNodes.includes(package)) {
                    delete packagesToUpdateWithDependencies[package];
                } else {
                    packagesToUpdateWithDependencies[package] = packagesToUpdateWithDependencies[package].filter(element => {
                    return !rootNodes.includes(element);
                });
                if(!packagesToUpdateWithDependencies[package].length) {
                    newRootNodes.push(package);
                }
            }
        }
        rootNodes = newRootNodes;
    }
    return sortedPackagesToUpdate;
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

async function getSortedPackagesToUpdate() {
    let sfdxProject = fs.readFileSync('sfdx-project.json');
    let sfdxProjectJSON = JSON.parse(sfdxProject);
    let changedPackageDirectories = await getChangedPackageDirectories();
    let packagesToUpdate = getPackagesToUpdate(changedPackageDirectories, sfdxProjectJSON);
    let sortedPackagesToUpdate = sortPackagesToUpdate(packagesToUpdate, sfdxProjectJSON);
    process.stdout.write(sortedPackagesToUpdate.join(' '));
}

getSortedPackagesToUpdate();